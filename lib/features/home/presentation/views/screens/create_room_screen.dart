import 'package:chat_app/config/di/di.dart';
import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/ui_utils/dialog_utils.dart';
import 'package:chat_app/core/validators/app_validators.dart';
import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_events.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_states.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_view_model.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  RoomsViewModel viewModel=getIt<RoomsViewModel>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.sizeOf(context).width;
    var height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.chat_app,style: Theme.of(context).textTheme.headlineLarge,),
      ),
      body: BlocProvider<RoomsViewModel>(
        create: (context) => viewModel,
        child: BlocConsumer<RoomsViewModel,RoomsStates>(
          builder: (context, state) {
            final categories = CategoryEntity.categories;
            final selectedCategory = state.selectedCategory;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 0.04*width),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.create_new_room,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.blackColor
                    ),),
                    SizedBox(height: 0.01*height,),
                    Icon(Icons.groups,size: 180,color: AppColors.primaryColor,),
                    SizedBox(height: 0.03*height,),
                    TextFormField(
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.room_name
                      ),
                      validator: (value) {
                        return AppValidators.validateRoomName(value, context);
                      },
                    ),
                    SizedBox(height: 0.02*height,),
                    DropdownButtonFormField<CategoryEntity>(
                      // ignore: deprecated_member_use
                      value: selectedCategory,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.select_category
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem<CategoryEntity>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(category.iconData,size: 20,color: AppColors.primaryColor,),
                              SizedBox(width: 0.015*width,),
                              Text(category.getLocalizedName(context),style: Theme.of(context).textTheme.bodyMedium,)
                            ],
                          )
                        );
                      },).toList(), 
                      onChanged: (category) {
                        if(category!=null){
                          viewModel.doIntent(SelectCategoryEvent(category));
                        }
                      },
                      validator: (value) {
                        return AppValidators.validateCategory(value, context);
                      },
                    ),
                    SizedBox(height: 0.02*height,),
                    TextFormField(
                      controller: descriptionController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.room_description,
                      ),
                      validator: (value) {
                        return AppValidators.validateDescription(value, context);
                      },
                    ),
                    SizedBox(height: 0.03*height,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState?.validate()==true && selectedCategory!=null){
                            viewModel.doIntent(CreateRoomEvent(
                              name: nameController.text, 
                              description: descriptionController.text, 
                              categoryId: selectedCategory.id,
                            ));
                          }
                        }, 
                        child: Text(AppLocalizations.of(context)!.create_room)
                      ),
                    )
                  ],
                )
              ),
            );
          }, 
          listener: (context, state) {
            if(state.createRoomState?.isLoading==true){
              DialogUtils.showLoading(context: context, loadingText: AppLocalizations.of(context)!.loading);
            }else if(state.createRoomState?.isLoading==false && state.createRoomState?.data!=null){
              DialogUtils.removeLoading(context: context);
              DialogUtils.showMessage(
                context: context,
                title: AppLocalizations.of(context)!.success, 
                message: AppLocalizations.of(context)!.room_success,
                posActionName: AppLocalizations.of(context)!.ok,
                posAction: () {
                  Navigator.pop(context);
                },
              );
            }else if(state.createRoomState?.isLoading==false && state.createRoomState?.errorMessage!=null){
              DialogUtils.removeLoading(context: context);
              DialogUtils.showMessage(
                context: context,
                title: AppLocalizations.of(context)!.failure, 
                message: state.createRoomState!.errorMessage!,
                negActionName: AppLocalizations.of(context)!.cancel,
              );
            }
          },
        ),
      ),
    );
  }
}
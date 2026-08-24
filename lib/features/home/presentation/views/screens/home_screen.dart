import 'package:chat_app/config/di/di.dart';
import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_events.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_states.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_view_model.dart';
import 'package:chat_app/features/home/presentation/views/widgets/room_item.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  RoomsViewModel viewModel=getIt<RoomsViewModel>();
  @override
  void initState() {
    viewModel.doIntent(GetRoomsEvent());
    super.initState();
  }
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
        child: BlocBuilder<RoomsViewModel,RoomsStates>(
          builder: (context, state) {
            if(state.roomsState?.isLoading==false && state.roomsState?.errorMessage!=null){
              return Center(child: Text(state.roomsState!.errorMessage!,style: Theme.of(context).textTheme.bodyLarge,),);
            }else if(state.roomsState?.isLoading==false && state.roomsState!.data!.isEmpty){
              return Center(child: Text(AppLocalizations.of(context)!.no_rooms,style: Theme.of(context).textTheme.bodyLarge,),);
            }else if(state.roomsState?.isLoading==false && state.roomsState?.data!=null && state.roomsState!.data!.isNotEmpty){
              return GridView.builder(
                padding: EdgeInsets.only(top: 0.01*height,right: 0.04*width,left: 0.04*width),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.04*width,
                  mainAxisSpacing: 0.02*height,
                  childAspectRatio: 0.7
                ),
                itemCount: state.roomsState!.data!.length, 
                itemBuilder: (context, index) {
                  return RoomItem(room: state.roomsState!.data![index]);
                },
              );
            }else{
              return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createRoom).then((value) {
            viewModel.doIntent(GetRoomsEvent());
          },);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
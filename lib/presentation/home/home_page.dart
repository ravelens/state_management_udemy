import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management_udemy/application/profile/bloc/profileb_bloc.dart';
import 'package:state_management_udemy/domain/auth/model/login_response.dart';
import 'package:state_management_udemy/domain/core/user/model/user_response.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.loginResponse}) : super(key: key);

  final LoginResponse loginResponse;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilebBloc()..add(ProfilebEvent.getAllUserData()),
      child: BlocConsumer<ProfilebBloc, ProfilebState>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () {},
            isLoading: (value) {
              print("Is Loading");
            },
            isSuccess: (value) {
              print(value.userResponse.toJson());
            },
          );
        },
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => homePageError(),
            isLoading: (e) => homePageLoading(),
            isSuccess: (value) => homePageScaffold(value.userResponse.data),
            isError: (value) => homePageError(),
          );
        },
      ),
    );
  }

  Scaffold homePageError() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Something Wrong"),
          ),
          IconButton(
            onPressed: () {
              context.bloc<ProfilebBloc>().add(ProfilebEvent.getAllUserData());
            },
            icon: Icon(Icons.replay),
          ),
        ],
      ),
    );
  }

  Scaffold homePageLoading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Scaffold homePageScaffold(List<Data> _data) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loginResponse.token),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (ctx, idx) => ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                _data[idx].avatar,
              ),
            ),
            subtitle: Text(_data[idx].email),
            title: Text(_data[idx].firstName),
          ),
        ),
      ),
    );
  }
}

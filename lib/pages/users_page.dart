//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

//Providers
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

//Models
import '../models/chat_user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                primaryAction: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    _auth.logout();
                  },
                ),
              ),
              CustomTextField(
                onEditingComplete: (value) {
                  _pageProvider.getUsers(name: value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _usersList() {
    List<ChatUser>? users = _pageProvider.users;
    return Expanded(child: () {
      if (users != null) {
        if (users.isNotEmpty) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              developer.log("\x1B[32m Users in userPage ::: $users\x1B[0m");
              return CustomListViewTile(
                height: _deviceHeight * 0.10,
                title: users[index].name,
                subtitle: "Last Active: ${users[index].lastDayActive()}",
                imagePath: users[index].imageURL,
                isActive: users[index].wasRecentlyActive(),
                isSelected: _pageProvider.selectedUsers.contains(
                  users[index],
                ),
                onTap: () {
                  _pageProvider.updateSelectedUsers(
                    users[index],
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "No Users Found.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _pageProvider.selectedUsers.length == 1
            ? "Chat With ${_pageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _pageProvider.createChat();
        },
      ),
    );
  }
}

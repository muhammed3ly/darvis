import 'package:chat_bot/widgets/profile_screen_widgets/edit_email.dart';
import 'package:chat_bot/widgets/profile_screen_widgets/edit_password.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatefulWidget {
  final String title, value;
  final Function editFunction;
  final bool password;
  ProfileItem({
    @required this.title,
    @required this.value,
    @required this.editFunction,
    this.password = false,
  });
  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  TextEditingController _controller;
  bool _editing;
  @override
  void initState() {
    super.initState();
    _editing = false;
    _controller = TextEditingController();
    _controller.text = widget.value;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _tryEdit() {
    if (widget.value.trim() != _controller.text.trim() &&
        _controller.text.trim().isNotEmpty) {
      widget.editFunction(_controller.text);
    } else if (_controller.text.trim().isEmpty) {
      if (mounted) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Can\'t update ${widget.title.toLowerCase()} with empty text.'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  void _startEditing() {
    if (widget.title == 'Password') {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => EditPassword(widget.editFunction)));
    } else if (widget.title == 'Email Address') {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => EditEmail(widget.editFunction)));
    } else {
      setState(() {
        _editing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Color.fromRGBO(53, 77, 175, 1),
                  ),
                ),
                Expanded(
                  child: TextField(
                    enabled: _editing,
                    controller: _controller,
                    style: !_editing
                        ? TextStyle(
                            color: Colors.grey[400],
                          )
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: _editing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            _controller.text = widget.value;
                            _editing = false;
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.red[700],
                        ),
                      ),
                      InkWell(
                        onTap: _tryEdit,
                        child: Icon(
                          Icons.done,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: _startEditing,
                    child: Icon(
                      Icons.edit,
                      color: Color.fromRGBO(53, 77, 175, 1),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EditPasswordTFs extends StatefulWidget {
  final String title;
  final FocusNode myFocusNode;
  final Function onSubmitted;
  final TextEditingController controller;
  final bool pass;
  EditPasswordTFs(
      {@required this.title,
      @required this.onSubmitted,
      @required this.controller,
      this.myFocusNode,
      this.pass = true});
  @override
  _EditPasswordTFsState createState() => _EditPasswordTFsState();
}

class _EditPasswordTFsState extends State<EditPasswordTFs> {
  bool _show;
  @override
  void initState() {
    super.initState();
    _show = false;
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
                    controller: widget.controller,
                    obscureText: widget.pass ? !_show : false,
                    onSubmitted: widget.onSubmitted,
                    focusNode: widget.myFocusNode ?? widget.myFocusNode,
                    textInputAction: widget.title.startsWith('Confirm') ||
                            widget.title == 'Password'
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: widget.title == 'Email Address'
                          ? 'Your new email'
                          : widget.title == 'Current Password' ||
                                  widget.title == 'Password'
                              ? 'Your current password'
                              : widget.title == 'New Password'
                                  ? '6 characters at least'
                                  : 'Retype your new password',
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
          if (widget.pass)
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: _show
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _show = false;
                        });
                      },
                      child: Icon(
                        Icons.visibility_off,
                        color: Color.fromRGBO(53, 77, 175, 1),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          _show = true;
                        });
                      },
                      child: Icon(
                        Icons.visibility,
                        color: Color.fromRGBO(53, 77, 175, 1),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

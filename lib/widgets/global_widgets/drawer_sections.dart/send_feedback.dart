import 'package:chat_bot/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SendFeedback extends StatefulWidget {
  final double initialRating;
  SendFeedback(this.initialRating);
  @override
  _SendFeedbackState createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<SendFeedback>
    with TickerProviderStateMixin {
  AnimationController titleController, buttonController, feedbackController;
  TextEditingController _feedbackTEC;
  double _rating;
  bool _firstRun;
  GlobalKey<ScaffoldState> _scaffold;
  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _firstRun = true;
    _scaffold = GlobalKey<ScaffoldState>();
    _feedbackTEC = TextEditingController();
    titleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    feedbackController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_firstRun) {
      _firstRun = false;
      await Future.delayed(Duration(milliseconds: 150));
      titleController.forward();
      feedbackController.forward();
      buttonController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    buttonController.dispose();
    feedbackController.dispose();
    _feedbackTEC.dispose();
  }

  void showError(String msg) {
    _scaffold.currentState.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  void closeScreen() async {
    _scaffold.currentState.removeCurrentSnackBar();
    await Future.wait(
      [
        titleController.reverse(),
        feedbackController.reverse(),
        buttonController.reverse(),
      ],
    );
    Navigator.of(context).pop();
  }

  void validateThenEdit() {
    String feedback = _feedbackTEC.text;
    if (feedback.trimRight().isEmpty || _rating == 0.0) {
      showError('Please mention your reasons for this rating.');
    } else {
      Provider.of<User>(context, listen: false).sendFeedback(feedback, _rating);
      closeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _scaffold.currentState.removeCurrentSnackBar();
        await Future.wait(
          [
            titleController.reverse(),
            feedbackController.reverse(),
            buttonController.reverse(),
          ],
        );
        return true;
      },
      child: Scaffold(
        key: _scaffold,
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: closeScreen,
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        curve: Curves.fastOutSlowIn,
                        parent: titleController,
                      ),
                      child: Center(
                        child: FittedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Send',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Feedback',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Hero(
                        tag: 'rating',
                        child: RatingBar(
                          initialRating: widget.initialRating,
                          tapOnlyMode: true,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          unratedColor: Colors.white,
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        curve: Curves.fastOutSlowIn,
                        parent: feedbackController,
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.09,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _feedbackTEC,
                          textInputAction: TextInputAction.newline,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: 'Your reasons for this rating.',
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        curve: Curves.fastOutSlowIn,
                        parent: buttonController,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          shape: StadiumBorder(),
                          color: Color.fromRGBO(53, 77, 175, 1),
                          child: Text(
                            'Send Feedback',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: validateThenEdit,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

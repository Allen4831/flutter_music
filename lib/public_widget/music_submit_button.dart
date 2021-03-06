import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music/common/music_store.dart';
typedef GestureTapCallback = void Function(_MusicSubmitButtonState state);

typedef WaitingCallback<T> = void Function();

typedef SuccessCallback<T> = void Function(T);

typedef FiledCallback<T>   = void Function(Object error);


class MusicSubmitButton<T> extends StatefulWidget {
  MusicSubmitButton({
    Key key,
    this.isEnable : true,
    this.onTap,
    this.title,
    this.margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
    this.loadingText: "正在加载...",
    this.waitingCallback,
    this.successCallback,
    this.filedCallback,
    this.backGroundColor,
    this.titleStyle,
    this.loadingStyle

  }): super(key :key);

  final GestureTapCallback onTap;
  final String title;
  final EdgeInsets  margin;
  final String loadingText;

  final WaitingCallback<T> waitingCallback;
  final SuccessCallback<T> successCallback;
  final FiledCallback<T>  filedCallback;
  final TextStyle titleStyle;
  final TextStyle loadingStyle;
  final Color backGroundColor;
  final bool isEnable;
  @override
  _MusicSubmitButtonState createState() => _MusicSubmitButtonState<T>();
}

class _MusicSubmitButtonState<T> extends State<MusicSubmitButton<T>> {


  ConnectionState connectionState = ConnectionState.none;

  void requestFuture(Future<T> future){
    _subscribe(future);

  }

  void _subscribe(Future<T> future){
    if(future !=null){

      setState(() {
        connectionState =  ConnectionState.waiting;
      });
      if(widget.waitingCallback != null){
        widget.waitingCallback();
      }
      Future.delayed(Duration(milliseconds: 500), (){
        future.then<void>((T data){

          if(widget.successCallback != null){
            widget.successCallback(data);
          }

          setState(() {
            connectionState =  ConnectionState.done;
          });

        },onError: (Object error){
          print(error);
          if(widget.filedCallback != null){
            widget.filedCallback(error);
          }

          setState(() {
            connectionState =  ConnectionState.done;
          });

        });

      });


    }

  }


  Widget _activityIndicator(){
    TextStyle loadingStyle = widget.loadingStyle ?? TextStyle(color: MusicStore.Theme(context).titleColor,fontWeight: FontWeight.w600,fontSize: 17);
    return  Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(
            radius: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(widget.loadingText,style: loadingStyle,)

          )
        ],
      )
    );
  }

  Widget _titleText(){

    TextStyle titleStyle = widget.titleStyle ?? TextStyle(color: MusicStore.Theme(context).titleColor,fontWeight: FontWeight.w600,fontSize: 17);
    return Text(widget.title,textAlign: TextAlign.center,
      style: titleStyle,);
  }

  @override
  Widget build(BuildContext context) {
    Color backGrounColor = widget.backGroundColor ?? MusicStore.Theme(context).theme;
    return MusicGestureDetector(
      onTap: widget.isEnable == false ? null : (){

        if(connectionState != ConnectionState.waiting){
          widget.onTap(this);
        }

      },
      child:Opacity(
        opacity: widget.isEnable == false ? 0.6 : 1.0,
        child:  Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 15,bottom: 15),
            margin:widget.margin,
            child: connectionState == ConnectionState.waiting ? _activityIndicator() : _titleText(),
            decoration:
            BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backGrounColor,
                boxShadow: MusicStore.boxShow(context, -10, 10))

        ),
      )
    );
  }



}



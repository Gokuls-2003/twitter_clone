import 'package:flutter/widgets.dart';
import 'package:twitter_clone/theme/pallate.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans =[];

    text.split(' ').forEach((element){
      if(element.startsWith('#')){
        textspans.add(
          TextSpan(
            text: '$element',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          )
        );
      }else if(element.startsWith('www.') || element.startsWith('https://')){
        TextSpan(
            text: '$element',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            )
          );
      }
    });
    return RichText(text: TextSpan(
      children: textspans,
    ),);
  }
}
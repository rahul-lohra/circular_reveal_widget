## Circular Reveal Widget

## Demo Animation

<a href="https://gifyu.com/image/9Vrs"><img src="https://s3.gifyu.com/images/reveal_anim.gif"
                                            width="500" height="300"
                                            alt="reveal_anim.gif" border="0" /></a>

## Getting Started
```
class ButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RevealWidget(Container(
        color: Colors.red,
        width: 100,
        height: 60,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Hello",
            style: TextStyle(fontSize: 20),
          ),
        )));
  }
}
```
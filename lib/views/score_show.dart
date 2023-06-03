import 'package:flutter/material.dart';

class ScoreShow extends StatefulWidget {

  ScoreShow({required this.score, required this.nomComplet});
    int score = 0;
    String? nomComplet;

  @override
  _ScoreShowState createState() => _ScoreShowState();
}

class _ScoreShowState extends State<ScoreShow>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void increaseScore() {
    setState(() {
      _animationController!.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre Score'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/ideas.png" ,),
            
          ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              
              
              AnimatedBuilder(
                animation: _animation!,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + (_animation!.value * 0.5),
                    child: child,
                  );
                },
                child: TextButton(
                  onPressed:increaseScore,
                  child: Padding(
                    padding: const EdgeInsets.only(right:6.0),
                    child: Text(widget.score.toString(),
                    style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
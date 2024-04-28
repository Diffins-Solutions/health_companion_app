class ChartData{
  String x;
  double y1;
  double? y2;
  double? y3;
  double? y4;
  double? y5;
  double? y6;

  ChartData(this.x, this.y1,
      {this.y2 = 0.0,
        this.y3 = 0.0,
        this.y4 = 0.0,
        this.y5 = 0.0,
        this.y6 = 0.0});

  /// 1. sadness => 🙁
  /// 2. joy => 😀
  /// 3. love => 🥰
  /// 4. anger => 😡
  /// 5. fear => 😰
  /// 6. surprise

  void addEmotion(String emotion){
    if(emotion == 'sadness'){
      y1++;
    }else if(emotion == 'joy'){
      y2 = y2! + 1;
    }else if(emotion == 'love'){
      y3 =  y3! + 1;
    }else if(emotion == 'anger'){
      y4 = y4! + 1;
    }else if(emotion == 'fear'){
      y5 = y5! + 1;
    }else if(emotion == 'surprise'){
      y6 = y6! + 1;
    }

  }

  void printData(){
    print('$x $y1 $y2 $y3 $y4 $y5 $y6');
  }
}
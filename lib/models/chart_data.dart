class ChartData{
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4, this.y5, this.y6);
  String x;
  double y1;
  double y2;
  double y3;
  double y4;
  double y5;
  double y6;

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
      y2++;
    }else if(emotion == 'love'){
      y3++;
    }else if(emotion == 'anger'){
      y4++;
    }else if(emotion == 'fear'){
      y5++;
    }else if(emotion == 'surprise'){
      y6++;
    }

  }

  void printData(){
    print('$x $y1 $y2 $y3 $y4 $y5 $y6');
  }
}
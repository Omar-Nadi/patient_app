class Results {
  String name;
  String date;
  String time;
  String imageUrl;

  Results({
    required this.name,
    required this.date,
    required this.time,
    required this.imageUrl,
  });
  Map toJson() => {
        "name": name,
        "date": date,
        "time": time,
        "imageUrl": imageUrl,
      };
}

Results result1 = Results(
    date: "03 Nov 2022",
    imageUrl:
        "https://images.examples.com/wp-content/uploads/2017/04/Printable-Medical.jpg",
    name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    time: "09:01 AM");
Results result2 = Results(
    date: "09 Nov 2022",
    imageUrl:
        "https://images.sampleforms.com/wp-content/uploads/2019/01/Medical-Report-Form-Sample.jpg",
    name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    time: "12:58 AM");
Results result3 = Results(
    date: "10 Nov 2022",
    imageUrl: "https://www.pdffiller.com/preview/52/342/52342784/large.png",
    name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    time: "010:24 AM");
Results result4 = Results(
    date: "13 Nov 2022",
    imageUrl:
        "https://static.wixstatic.com/media/ccd3b0_22e49cc343ab4460848348cfc53e0895~mv2.jpg/v1/crop/x_0,y_36,w_652,h_863/fill/w_562,h_742,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/HeartTrends%20Test%20Report%20(typical).jpg",
    name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    time: "03:30 AM");

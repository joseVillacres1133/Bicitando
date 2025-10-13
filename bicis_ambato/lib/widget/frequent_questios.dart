import 'package:bicis_ambato/data/auth_provider.dart';
import 'package:flutter/material.dart';

import '../data/models/odoo/FrequentQuestions.dart';
import '../style/style.dart';

class FrequentQuestionsContent extends StatefulWidget {
  _FrequentQuestionsState createState() => _FrequentQuestionsState();
}

class _FrequentQuestionsState extends State<FrequentQuestionsContent> {
  late AuthProvider authProvider;
  late List<FrequentQuestion> frequentQuestions;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();
    frequentQuestions = [];
   
    //       frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 1?', 'The problem that I am running into is that the grid/listview do not scroll when I have Positioned widget AND I have explicitly named any BUT NOT ALL of its constructors, i.e. top:, bottom:, left:, right:. (Im lazily building the grid/listview lazily via builder).', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 2?', 'I have a work around/hack where I remove the Positioned and replace it with a PageView. The PageView then has a children: <Widget> [  Container()  ] that I then position via the margin constructors top: and left:.', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 3?', 'This will work for now, but not something that I want to implement for production. How can I get the grid/listview to scroll within a Positioned widget WITHOUT naming all of its constructors?', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 4?', 'I have a work around/hack where I remove the Positioned and replace it with a PageView. The PageView then has a children: <Widget> [  Container()  ] that I then position via the margin constructors top: and left:.', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 5?', 'respuesta', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 6?', 'I have a work around/hack where I remove the Positioned and replace it with a PageView. The PageView then has a children: <Widget> [  Container()  ] that I then position via the margin constructors top: and left:.', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 7?', 'respuesta', '', true));
    // frequentQuestions
    //     .add(FrequentQuestion('PREGUNTA FREQUENTE 8?', 'I have a work around/hack where I remove the Positioned and replace it with a PageView. The PageView then has a children: <Widget> [  Container()  ] that I then position via the margin constructors top: and left:.', '', true));
      
  }

  //monitoreando despachos

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFrequetQuestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: secondary,
          );
        } 
        // else if (snapshot.hasData == false) {
        //   return Container(
        //     color: whiteColor,
        //     child:
        //         const Center(child: Text('No existe términos y condiciones')),
        //   );
        // } 
        else {
          return ListView.builder(
            itemCount: frequentQuestions.length,
            itemBuilder: (context, index) {
              FrequentQuestion frequentQuestion;
              frequentQuestion = frequentQuestions[index];
              return 
                 ExpansionTile(
                initiallyExpanded: index.isEven,
                  title: Text(frequentQuestion.name,style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                  children: [
                  Text(frequentQuestion.description)
                  ]);
              
            },
          );
        }
      },
    );
  }

  Future<List<FrequentQuestion>> loadFrequetQuestions() async {
   
    await authProvider.getFrequentQuestions().then((value) 
    {
      print(value);
      if (value.isNotEmpty) {
        frequentQuestions = value;
      }
    }
    );
    return frequentQuestions;
  }
}

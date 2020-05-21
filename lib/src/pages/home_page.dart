import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movi_horizontal.dart';

class HomePage extends StatelessWidget {
  final _peliculas = new PeliculaProvider();

  @override
  Widget build(BuildContext context) {
    _peliculas.getPopulares();

    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Text('Peliculas en cines'),
            backgroundColor: Colors.indigoAccent,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchPelicula(),
                  );
                },
              )
            ]),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _peliculasPopulares(context),
          ],
        )));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: _peliculas.getEnCines(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 300, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _peliculasPopulares(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Populares',
                    style: Theme.of(context).textTheme.subhead)),
            SizedBox(height: 5.0),
            StreamBuilder(
              stream: _peliculas.popularesStream,
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    peliculas: snapshot.data,
                    siguientPagina: _peliculas.getPopulares,
                  );
                } else {
                  return Container(
                      height: 300,
                      child: Center(
                          child: Center(child: CircularProgressIndicator())));
                }
              },
            ),
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;

  final Function siguientPagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientPagina});

  final _pagecontroller = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;

    _pagecontroller.addListener(() {
      if (_pagecontroller.position.pixels >=
          _pagecontroller.position.maxScrollExtent - 200) {
        siguientPagina();
      }
    });

    return Container(
      height: screensize.height * 0.30,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pagecontroller,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-horizontal';

    final _peliculaTarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(children: <Widget>[
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg()),
              placeholder: AssetImage('assets/no-image.jpg'),
              fit: BoxFit.cover,
              height: 160.0,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          pelicula.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        ),
      ]),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: _peliculaTarjeta,
    );
  }

  // List<Widget> _tarjetas( BuildContext context){
  //   return peliculas.map((pelicula){
  //     return Container(
  //       margin: EdgeInsets.only(right:15.0),
  //       child: Column(
  //         children:<Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20.0),
  //             child: FadeInImage(
  //               image:NetworkImage(pelicula.getPosterImg()),
  //               placeholder: AssetImage('assets/no-image.jpg'),
  //               fit:BoxFit.cover,
  //               height: 160.0,
  //             ),
  //           ),
  //           SizedBox(height: 5.0),
  //           Text(pelicula.title,
  //           overflow: TextOverflow.ellipsis,
  //           style: Theme.of(context).textTheme.caption,
  //           ),
  //         ]
  //       ),
  //     );
  //   }).toList();
  // }
}

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class SearchPelicula extends SearchDelegate{

final seleccion='';
final peliculasProvider = new PeliculaProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query='';
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
      icon:AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,
        progress: transitionAnimation,      
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //el builder o instruccion que crea los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty){ 
      return Container();
      }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
            final _peliculas= snapshot.data;

            return ListView(
              children: _peliculas.map((pelicula){
                return ListTile(
                    leading: FadeInImage(
                        image: NetworkImage(pelicula.getPosterImg()),
                        placeholder: AssetImage('assets/no-image.jpg'),
                        fit:BoxFit.cover,
                        width: 50.0,
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.originalTitle),
                    onTap: (){
                      close(context, null);
                      pelicula.uniqueId ='';
                      Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                    },
                );
              }).toList(),
            );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }

}
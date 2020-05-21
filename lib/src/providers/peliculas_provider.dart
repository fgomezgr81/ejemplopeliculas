import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculaProvider{
  String _apky='5275af8b71aa1b5faf676774fb52806a';
  String _url='api.themoviedb.org';
  String _languaje='es-Es';
  int _popularesPage =0;

  bool cargando=false;

  List<Pelicula> _populares=new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function (List<Pelicula>) get popularesSink=>_popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream=>_popularesStreamController.stream;

  void desposeStream(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{
  final response =await http.get(url);
    final decodeData=json.decode(response.body);
    final peliculas=new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future <List<Pelicula>> getEnCines() async{
    final url =Uri.https(_url, '3/movie/now_playing',{
      'api_key':_apky,
      'languaje': _languaje
    });

    return await _procesarRespuesta(url);
  }

  
  Future<List<Pelicula>> getPopulares() async{

    if(cargando) return [];

    cargando = true;

    _popularesPage ++;

    final url =Uri.https(_url, '3/movie/popular',{
      'api_key':_apky,
      'languaje': _languaje,
      'page':_popularesPage.toString()
    });

    final resp= await _procesarRespuesta(url);
    
    _populares.addAll(resp);

    popularesSink(_populares);

    cargando=false;

    return resp;
  }

  Future<List<Actor>> getCast(String peliculaID) async{
    final url =Uri.https(_url,'3/movie/$peliculaID/credits',{
       'api_key':_apky,
      'languaje': _languaje
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final casting= new Cast.fromJsonList(decodeData['cast']);
    
    return casting.actores;
  }

  Future <List<Pelicula>> buscarPelicula(String query) async{
    final url =Uri.https(_url, '3/search/movie',{
      'api_key':_apky,
      'languaje': _languaje,
      'query': query
    });

    return await _procesarRespuesta(url);
  }

}
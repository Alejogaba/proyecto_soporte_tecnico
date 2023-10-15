import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/backend/controlador_dependencias.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/casos_por_dependencia.dart';
import 'package:login2/model/dependencias.dart';

class InterfazEstadisticas extends StatefulWidget {
  @override
  _InterfazEstadisticasState createState() => _InterfazEstadisticasState();
}

class _InterfazEstadisticasState extends State<InterfazEstadisticas> {
  List<CasosPorDependencia> casosPorDependencias = [];

  Future<List<CasosPorDependencia>> obtenerCasos() async {
    CasosController casosController = new CasosController();
    List<CasosPorDependencia> contadorDependencias = [];
    // Supongamos que tienes una lista de casos llamada "casos" que contiene objetos Caso con una propiedad "dependencia" que representa la dependencia a la que están asociados.
    List<Caso> casos = await casosController
        .obtenerCasosFuture(); // Supongamos que obtuviste tus casos desde Firebase

// Crear un mapa para contar casos por dependencia

    for (Caso caso in casos) {
      String dependencia = caso.uidDependencia;

      if (!(contadorDependencias.any(
        (element) {
          return element.uidDependencia == caso.uidDependencia ? true : false;
        },
      ))) {
        log('Dependencia no repetida:' + dependencia);
        int dependenciasCount =
            await casosController.contarCasosPorDependencia(dependencia);
        Dependencia nombreDependencia =
            await ControladorDependencias().cargarDependenciaUID(dependencia);
        log('Dependencia no repetida nombre:' + nombreDependencia.nombre);
        contadorDependencias.add(CasosPorDependencia(
            dependencia, nombreDependencia.nombre, dependenciasCount));
      }
    }

    return contadorDependencias;
  }

  @override
  void initState() {
    super.initState();
    obtenerCasos().then((casos) {
      setState(() {
        // Procesa los datos para contar casos por dependencias y llena la lista casosPorDependencias
        // Por ejemplo, puedes utilizar un bucle para contar casos por dependencia
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas de Casos por Dependencia'),
      ),
      body: FutureBuilder<List<CasosPorDependencia>>(
        future: obtenerCasos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Procesa los datos para contar casos por dependencias y llena la lista casosPorDependencias
            // Por ejemplo, puedes utilizar un bucle para contar casos por dependencia

            return Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  scrollDirection: Axis
                      .horizontal, // Establece la dirección del desplazamiento a horizontal
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 50, 2, 2),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            1.25, // Ajusta el ancho de acuerdo a tus necesidades
                        child: BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    log("Value: " + value.toString());
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < snapshot.data!.length) {
                                      return Text(snapshot
                                          .data![value.toInt()].dependencia);
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                  color: const Color(0xff37434d), width: 2),
                            ),
                            barGroups: snapshot.data!.map((caso) {
                              return BarChartGroupData(
                                x: snapshot.data!.indexOf(caso).toInt(),
                                barsSpace: 12,
                                barRods: [
                                  BarChartRodData(
                                      toY: caso.numeroCasos.toDouble(),
                                      width: 30,
                                      borderRadius: BorderRadius.circular(2),
                                      ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

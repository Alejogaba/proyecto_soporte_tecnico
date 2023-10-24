import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colombia_holidays/colombia_holidays.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login2/auth/firebase_auth/auth_helper.dart';
import 'package:login2/backend/controlador_caso.dart';
import 'package:login2/backend/controlador_dependencias.dart';
import 'package:login2/flutter_flow/flutter_flow_theme.dart';
import 'package:login2/model/caso.dart';
import 'package:login2/model/casos_por_dependencia.dart';
import 'package:login2/model/dependencias.dart';
import 'package:login2/model/tiempo_promedio.dart';
import 'package:login2/model/usuario.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../flutter_flow/flutter_flow_util.dart';

class InterfazEstadisticas extends StatefulWidget {
  const InterfazEstadisticas({
    Key? key,
  }) : super(key: key);

  @override
  _InterfazEstadisticasState createState() => _InterfazEstadisticasState();
}

class _InterfazEstadisticasState extends State<InterfazEstadisticas> {
  List<CasosPorDependencia> casosPorDependencias = [];

  List<Color> gradientColors = [
    Color.fromARGB(206, 45, 129, 155),
    Color.fromARGB(255, 27, 90, 109),
  ];
  List<int> showingTooltipOnSpots = [0, 1];
  int a = 0;
  TextStyle styleVerde = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color.fromARGB(255, 14, 114, 36));
  TextStyle styleAzul = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color.fromARGB(255, 57, 89, 116));
  DateTime now = DateTime.now();
  DateTime fechaInicialCalendario = DateTime.now();
  DateTime fechaFinalCalendario = DateTime.now();

  bool showAvg = false;
  DateTime? datePicked1;
  DateTime? datePicked2;
  ColombiaHolidays holidays = ColombiaHolidays();
  List<DateTime> _listadiasFestivos = [];
  DateRangePickerController _controller = DateRangePickerController();
  bool expandido = false;

  Future<List<CasosPorDependencia>> obtenerCasos() async {
    CasosController casosController = new CasosController();
    List<CasosPorDependencia> contadorDependencias = [];
    // Supongamos que tienes una lista de casos llamada "casos" que contiene objetos Caso con una propiedad "dependencia" que representa la dependencia a la que están asociados.
    List<Caso> casos = await casosController.obtenerCasoSolucionadosRangoFecha(
        retornarFechaInicial(),
        retornarFechaFinal()); // Supongamos que obtuviste tus casos desde Firebase

// Crear un mapa para contar casos por dependencia

    for (Caso caso in casos) {
      String dependencia = caso.uidDependencia;
      log('Fecha inicial: ' + DateFormat('yyyy-MM-dd – HH:mm:ss').format(now));
      if (caso.solucionado &&
          caso.fecha.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        now = caso.fecha;
      }

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

  Future<List<CasosPorDependencia>> obtenerCasosFuncionario() async {
    CasosController casosController = new CasosController();
    List<CasosPorDependencia> contadorFuncionarios = [];
    // Supongamos que tienes una lista de casos llamada "casos" que contiene objetos Caso con una propiedad "dependencia" que representa la dependencia a la que están asociados.
    List<Caso> casos = await casosController.obtenerCasoSolucionadosRangoFecha(
        retornarFechaInicial(),
        retornarFechaFinal()); // Supongamos que obtuviste tus casos desde Firebase

// Crear un mapa para contar casos por dependencia

    for (Caso caso in casos) {
      if (caso.finalizadoPor != null) {
        String finalizadoPor = caso.finalizadoPor!;
        log('Fecha inicial: ' +
            DateFormat('yyyy-MM-dd – HH:mm:ss').format(now));
        if (caso.solucionado &&
            caso.fecha.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
          now = caso.fecha;
        }

        if (!(contadorFuncionarios.any(
          (element) {
            return element.uidFuncionario == caso.finalizadoPor ? true : false;
          },
        ))) {
          log('Dependencia no repetida:' + finalizadoPor);
          int funcionariosCount =
              await casosController.contarCasosPorFuncionario(finalizadoPor);
          Usuario usuario =
              await AuthHelper().getUsuarioFutureUID(finalizadoPor) ??
                  Usuario(nombre: 'null',urlImagen: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png');
          contadorFuncionarios.add(CasosPorDependencia(
              '', usuario.nombre!, funcionariosCount,
              uidFuncionario: finalizadoPor,urlFuncionario: usuario.urlImagen));
        }
      }
    }

    return contadorFuncionarios;
  }

  @override
  void initState() {
    diasFestivos();
    fechaInicialCalendario = DateTime(now.year, now.month, now.day, 0, 0, 1);
    fechaFinalCalendario = DateTime(now.year, now.month, now.day, 23, 59, 59);
    super.initState();
    casosPorDependencias = [];
    if (casosPorDependencias.isEmpty) {
      obtenerCasos().then((casos) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text('Resumen Estadístico'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              log('expandido: ' + isExpanded.toString());
              setState(() {});
              if (expandido) {
                expandido = false;
              } else {
                expandido = true;
              }
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                                child: Icon(Icons.calendar_month,
                                    size: 30,
                                    color:
                                        FlutterFlowTheme.of(context).primary),
                              ),
                              Text(
                                'Fecha',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: (compararFechas(retornarFechaInicial(),
                                    retornarFechaFinal()))
                                ? Text(
                                    retornarFechaInicial().day ==
                                            DateTime.now().day
                                        ? 'Hoy'
                                        : DateFormat('MMMM dd', 'es_CO')
                                            .format(retornarFechaInicial()),
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.bold),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        'Desde el ',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                                color: Color.fromARGB(
                                                    255, 62, 119, 121),
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${DateFormat('dd').format(retornarFechaInicial())} de ${DateFormat('MMMM', 'es_CO').format(retornarFechaInicial())} ',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                                color: Color.fromARGB(
                                                    255, 41, 104, 78),
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' hasta el ',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                                color: Color.fromARGB(
                                                    255, 62, 119, 121),
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${DateFormat('dd').format(retornarFechaFinal())} de ${DateFormat('MMMM', 'es_CO').format(retornarFechaFinal())} ',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                                color: Color.fromARGB(
                                                    255, 41, 104, 78),
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 45),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: rangoFechasLocal(),
                      ),
                    ],
                  ),
                ),
                isExpanded:
                    expandido, // Cambia a true si quieres que esté expandido inicialmente
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                  child: Icon(Icons.bar_chart,
                      size: 30, color: FlutterFlowTheme.of(context).primary),
                ),
                Text(
                  'Total de Casos por Dependencia',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                      color: FlutterFlowTheme.of(context).primary,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          FutureBuilder<List<CasosPorDependencia>>(
            future: obtenerCasos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  )),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return Text('Error: ${snapshot.error}');
              } else {
                return AspectRatio(
                  aspectRatio: 1.70,
                  child: snapshot.data!.length > 3
                      ? ListView(
                          scrollDirection: Axis
                              .horizontal, // Establece la dirección del desplazamiento a horizontal
                          children: [
                            graficoCasosDependencia(context, snapshot),
                          ],
                        )
                      : graficoCasosDependencia(context, snapshot),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                  child: Icon(Icons.access_time,
                      size: 30, color: Color.fromARGB(255, 27, 121, 136)),
                ),
                Text(
                  'Tiempo promedio de respuesta por día',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                      color: Color.fromARGB(255, 27, 121, 136),
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          FutureBuilder<List<TiempoPromedioDia>>(
            future: calcularTiempoPromedio(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  )),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<FlSpot> listaY = [];
                int i = 0;
                for (var element in snapshot.data!) {
                  listaY.add(FlSpot(i.toDouble(), element.promedio));
                  i++;
                }
                return AspectRatio(
                  aspectRatio: 1.70,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 14,
                      left: 4,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(
                      graficoTiempoRespuesta(snapshot.data!, listaY),
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                  child: Icon(Icons.check,
                      size: 30, color: FlutterFlowTheme.of(context).primary),
                ),
                Text(
                  'Total de Casos resueltos por Técnico',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                      color: FlutterFlowTheme.of(context).primary,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          FutureBuilder<List<CasosPorDependencia>>(
            future: obtenerCasosFuncionario(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  )),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return Text('Error: ${snapshot.error}');
              } else {
                return AspectRatio(
                  aspectRatio: 1.70,
                  child: snapshot.data!.length > 3
                      ? ListView(
                          scrollDirection: Axis
                              .horizontal, // Establece la dirección del desplazamiento a horizontal
                          children: [
                            graficoCasosFuncionario(context, snapshot),
                          ],
                        )
                      : graficoCasosFuncionario(context, snapshot),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Padding graficoCasosDependencia(
      BuildContext context, AsyncSnapshot<List<CasosPorDependencia>> snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 40, 12, 2),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Color.fromARGB(253, 206, 206, 206))),
          backgroundColor: Color.fromARGB(54, 51, 206, 46),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value.toInt().toString(),
                      style: styleVerde,
                    ),
                  );
                },
                showTitles: true,
                interval: 1,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < snapshot.data!.length) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: AutoSizeText(
                        snapshot.data![value.toInt()].dependencia,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                        style: styleVerde,
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border:
                Border.all(color: Color.fromARGB(255, 14, 114, 36), width: 2),
          ),
          barGroups: snapshot.data!.map((caso) {
            return BarChartGroupData(
              x: snapshot.data!.indexOf(caso).toInt(),
              barsSpace: 12,
              barRods: [
                BarChartRodData(
                  color: FlutterFlowTheme.of(context).primary,
                  toY: caso.numeroCasos.toDouble(),
                  width: 30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Padding graficoCasosFuncionario(
      BuildContext context, AsyncSnapshot<List<CasosPorDependencia>> snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 40, 12, 2),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Color.fromARGB(253, 206, 206, 206))),
          backgroundColor: Color.fromARGB(54, 51, 206, 46),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value.toInt().toString(),
                      style: styleVerde,
                    ),
                  );
                },
                showTitles: true,
                interval: 1,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < snapshot.data!.length) {
                    return Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 3, 2),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(
                                snapshot.data![value.toInt()].urlFuncionario),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: AutoSizeText(
                            snapshot.data![value.toInt()].dependencia,
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                            style: styleVerde,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border:
                Border.all(color: Color.fromARGB(255, 14, 114, 36), width: 2),
          ),
          barGroups: snapshot.data!.map((caso) {
            return BarChartGroupData(
              x: snapshot.data!.indexOf(caso).toInt(),
              barsSpace: 12,
              barRods: [
                BarChartRodData(
                  color: FlutterFlowTheme.of(context).primary,
                  toY: caso.numeroCasos.toDouble(),
                  width: 30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<List<TiempoPromedioDia>> calcularTiempoPromedio() async {
    List<TiempoPromedioDia> tiempoDiaSuma = [];
    List<FlSpot> spotsTiempoPromedio = [];
    log('a: $a');
    a++;
    List<Caso> casos = await CasosController()
        .obtenerCasoSolucionadosRangoFecha(
            retornarFechaInicial(), retornarFechaFinal());
    List<Duration> tiempos = [];
    List<TiempoPromedioDia> tiempoDia = [];

    List<String> dias =
        obtenerFechasEnRango(retornarFechaInicial(), retornarFechaFinal());

    casos.where((caso) => caso.solucionado).forEach((caso) {
      if (caso.fechaFinalizado != null) {
        dias.forEach((element) {
          if (DateFormat('yyyy-MMM dd', 'es_CO')
                  .format(caso.fechaFinalizado!)
                  .toLowerCase() ==
              element) {
            tiempoDia.add(TiempoPromedioDia(
                element, caso.fechaFinalizado!.difference(caso.fecha)));
            log('Dia: $element Duracion: ${caso.fechaFinalizado!.difference(caso.fecha)}');
          }
        });
        tiempos.add(caso.fechaFinalizado!.difference(caso.fecha));
      }
    });

    int i = 0;
    for (var diaSemana in dias) {
      int sumaDuracion = 0;
      int cantidad = 0;

      for (var element in tiempoDia) {
        if (element.dia == diaSemana) {
          log('tiempoDia: ${element.dia}');
          sumaDuracion += element.duracion.inMinutes;
          cantidad++;
        }
      }
      if (sumaDuracion != 0) {
        tiempoDiaSuma.add(TiempoPromedioDia(
            diaSemana.split('-')[1], Duration.zero,
            promedio: (sumaDuracion / cantidad)));
        spotsTiempoPromedio
            .add(FlSpot(i.toDouble(), (sumaDuracion / cantidad)));
        log('Resultado: i:$i Dia: $diaSemana Duracion promedio: ${(sumaDuracion / cantidad)}');
        i++;
      }
    }
    if (tiempos.isEmpty) {
      return tiempoDiaSuma;
    }
    return tiempoDiaSuma;
  }

  List<String> obtenerFechasEnRango(
      DateTime fechaInicial, DateTime fechaFinal) {
    List<String> fechas = [];
    DateTime diaActual = fechaInicial;

    while (diaActual.isBefore(fechaFinal)) {
      fechas.add(DateFormat('yyyy-MMM dd', 'es_CO')
          .format(diaActual)); // Obtener la fecha en formato de cadena
      diaActual = diaActual.add(Duration(days: 1));
    }

    return fechas;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData graficoTiempoRespuesta(
      List<TiempoPromedioDia> listaX, List<FlSpot> listaY) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: false,
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (response == null || response.lineBarSpots == null) {
            return;
          }
          if (event is FlTapUpEvent) {
            final spotIndex = response.lineBarSpots!.first.spotIndex;
            setState(() {
              if (showingTooltipOnSpots.contains(spotIndex)) {
                showingTooltipOnSpots.remove(spotIndex);
              } else {
                showingTooltipOnSpots.add(spotIndex);
              }
            });
          }
        },
        mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
          if (response == null || response.lineBarSpots == null) {
            return SystemMouseCursors.basic;
          }
          return SystemMouseCursors.click;
        },
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              const FlLine(
                color: Colors.pink,
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 2,
                  color: Color.fromARGB(255, 34, 136, 60),
                  strokeWidth: 2,
                  strokeColor: Color.fromARGB(255, 25, 105, 45),
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.pink,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                lineBarSpot.y.toString(),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 10,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 40, 62, 80),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 40, 62, 80),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < listaX.length) {
                log('Total dias: ' + listaX.length.toString());
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AutoSizeText(
                    listaX[value.toInt()].dia,
                    style: styleAzul,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                );
              } else {
                return Text('');
              }
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: AutoSizeText(
                  '${value.toInt().toString()} min',
                  minFontSize: 8,
                  overflow: TextOverflow.ellipsis,
                  style: styleAzul,
                  textAlign: TextAlign.center,
                ),
              );
            },
            showTitles: true,
            reservedSize: 60,
            interval: 10,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color.fromARGB(255, 57, 89, 116), width: 2),
      ),
      minX: 0,
      maxX: listaX.length.toDouble() - 1,
      minY: 0,
      maxY: 40,
      lineBarsData: [
        LineChartBarData(
          spots: listaY,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget rangoFechasLocal() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SfDateRangePicker(
            onSelectionChanged:
                (DateRangePickerSelectionChangedArgs args) async {
              final PickerDateRange dateRanges = (args.value);

              if (_controller.selectedRange != null) {
                log('rango fecha seleccionado');
                _controller.selectedRange = PickerDateRange(
                    _controller.selectedRange!.startDate,
                    _controller.selectedRange!.endDate);
              }
              if (args.value is PickerDateRange && args.value != null) {
                final DateTime rangeStartDate = args.value.startDate;
                DateTime rangeEndDate = rangeStartDate;
                if (args.value.endDate != null) {
                  rangeEndDate = args.value.endDate;
                }
                final DateTimeRange range =
                    DateTimeRange(start: rangeStartDate, end: rangeEndDate);
                /*Logger().i('El rango de fecha es:${range.duration.inDays}');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('fecha_inicio', rangeStartDate.toString());
                prefs.setString('fecha_fin', rangeEndDate.toString());*/
              }
            },
            initialDisplayDate: DateTime.now().subtract(Duration(days: 7)),
            controller: _controller,
            minDate: now,
            showActionButtons: true,
            cancelText: 'CANCELAR',
            onCancel: () {
              setState(() {
                _controller = DateRangePickerController();
              });
            },
            onSubmit: (p0) {
              setState(() {
                expandido = false;
              });
            },
            todayHighlightColor: FlutterFlowTheme.of(context).primary,
            selectionColor: FlutterFlowTheme.of(context).primary,
            rangeSelectionColor:
                FlutterFlowTheme.of(context).primary.withOpacity(0.30),
            startRangeSelectionColor: FlutterFlowTheme.of(context).primary,
            endRangeSelectionColor: FlutterFlowTheme.of(context).primary,
            selectionTextStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  fontSize: 20,
                  useGoogleFonts: GoogleFonts.asMap()
                      .containsKey(FlutterFlowTheme.of(context).bodySmall),
                ),
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            selectableDayPredicate: (DateTime dateTime) {
              if (dateTime.weekday == 7 ||
                  dateTime.weekday == 6 ||
                  (_listadiasFestivos.where((element) => element == dateTime))
                      .isNotEmpty) {
                return false;
              }
              return true;
            },
            enablePastDates: true,
            toggleDaySelection: true,
            showNavigationArrow: true,
            rangeTextStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                  fontSize: 16,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodySmallFamily),
                ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              trailingDatesTextStyle: FlutterFlowTheme.of(context)
                  .bodySmall
                  .override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    fontSize: 16,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodySmallFamily),
                  ),
              textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodySmallFamily),
                  ),
              blackoutDatesDecoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: const Color(0xFFF44436), width: 1),
                  shape: BoxShape.circle),
              weekendDatesDecoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  border: Border.all(
                      color: FlutterFlowTheme.of(context).primaryText,
                      width: 1),
                  shape: BoxShape.circle),
              specialDatesDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 113, 122),
                  border: Border.all(color: const Color(0xFF2B732F), width: 1),
                  shape: BoxShape.circle),
              disabledDatesTextStyle: FlutterFlowTheme.of(context)
                  .bodySmall
                  .override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodySmallFamily),
                  ),
              blackoutDateTextStyle: TextStyle(
                  color: Colors.white, decoration: TextDecoration.lineThrough),
              specialDatesTextStyle: const TextStyle(color: Colors.white),
            ),
            monthViewSettings: DateRangePickerMonthViewSettings(
                specialDates: _listadiasFestivos,
                dayFormat: 'EEE',
                numberOfWeeksInView: 5,
                firstDayOfWeek: 7,
                enableSwipeSelection: true,
                showTrailingAndLeadingDates: true),
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.extendableRange,
            //  initialSelectedRange:PickerDateRange(DateTime.now().subtract(Duration(days: 7)), DateTime.now()),
          ),
        ),
      ),
    );
  }

  DateTime retornarFechaInicial() {
    return _controller.selectedRange != null
        ? _controller.selectedRange!.startDate!
        : fechaInicialCalendario;
  }

  DateTime retornarFechaFinal() {
    if (_controller.selectedRange != null) {
      if (_controller.selectedRange!.endDate == null) {
        return DateTime(
            retornarFechaInicial().year,
            retornarFechaInicial().month,
            retornarFechaInicial().day,
            23,
            59,
            59);
      } else {
        return DateTime(
            _controller.selectedRange!.endDate!.year,
            _controller.selectedRange!.endDate!.month,
            _controller.selectedRange!.endDate!.day,
            23,
            59,
            59);
      }
    } else {
      return fechaFinalCalendario;
    }
  }

  bool compararFechas(DateTime fecha1, DateTime fecha2) {
    return fecha1.year == fecha2.year &&
        fecha1.month == fecha2.month &&
        fecha1.day == fecha2.day;
  }

  diasFestivos() async {
    if (_listadiasFestivos.length == 0) {
      DateTime fecha_fin = DateTime.now();
      final holidaysByYear2022 = await holidays.getHolidays(year: 2022);
      for (var holiday in holidaysByYear2022) {
        List<String> res = holiday.date.toString().split('/');
        _listadiasFestivos.add(
            DateTime(int.parse(res[2]), int.parse(res[1]), int.parse(res[0])));
        if (_listadiasFestivos.last > fecha_fin) {
          break;
        }
      }
      final holidaysByYear2023 = await holidays.getHolidays(year: 2023);
      for (var holiday in holidaysByYear2023) {
        List<String> res = holiday.date.toString().split('/');
        _listadiasFestivos.add(
            DateTime(int.parse(res[2]), int.parse(res[1]), int.parse(res[0])));
        if (_listadiasFestivos.last > fecha_fin) {
          break;
        }
      }
    }
  }
}

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/permissions_util.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'rowOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFF19DB8A),
          automaticallyImplyLeading: false,
          title: Text(
            'Audio Recording',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(
                          'Press the record button to start recording your voice. The recording will automatically stop after 60 seconds.',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                      if (_model.isRecording)
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 10.0, 0.0),
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'REC',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ).animateOnActionTrigger(
                            animationsMap['rowOnActionTriggerAnimation']!,
                          ),
                        ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FFButtonWidget(
                              onPressed: _model.isRecording
                                  ? null
                                  : () async {
                                      await requestPermission(
                                          microphonePermission);
                                      if (await getPermissionStatus(
                                          microphonePermission)) {
                                        _model.audioRecorder ??=
                                            AudioRecorder();
                                        if (await _model.audioRecorder!
                                            .hasPermission()) {
                                          final String path;
                                          final AudioEncoder encoder;
                                          if (kIsWeb) {
                                            path = '';
                                            encoder = AudioEncoder.opus;
                                          } else {
                                            final dir =
                                                await getApplicationDocumentsDirectory();
                                            path =
                                                '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
                                            encoder = AudioEncoder.aacLc;
                                          }
                                          await _model.audioRecorder!.start(
                                            RecordConfig(encoder: encoder),
                                            path: path,
                                          );
                                        } else {
                                          showSnackbar(
                                            context,
                                            'You have not provided permission to record audio.',
                                          );
                                        }

                                        setState(() {
                                          _model.isRecording = true;
                                          _model.isShowPlayer = false;
                                        });
                                        if (animationsMap[
                                                'rowOnActionTriggerAnimation'] !=
                                            null) {
                                          await animationsMap[
                                                  'rowOnActionTriggerAnimation']!
                                              .controller
                                              .repeat(reverse: true);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Permission denied!',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                      }
                                    },
                              text: 'Start',
                              options: FFButtonOptions(
                                width: 100.0,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF19DB8A),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                    ),
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(50.0),
                                disabledColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                disabledTextColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: !_model.isRecording
                                  ? null
                                  : () async {
                                      _model.recording =
                                          await _model.audioRecorder?.stop();
                                      if (_model.recording != null) {
                                        _model.recordingFile = FFUploadedFile(
                                          name: 'recording.mp3',
                                          bytes: await XFile(_model.recording!)
                                              .readAsBytes(),
                                        );
                                      }

                                      setState(() {
                                        _model.isRecording = false;
                                        _model.isShowPlayer = true;
                                      });
                                      if (animationsMap[
                                              'rowOnActionTriggerAnimation'] !=
                                          null) {
                                        animationsMap[
                                                'rowOnActionTriggerAnimation']!
                                            .controller
                                            .stop();
                                      }

                                      setState(() {});
                                    },
                              text: 'Stop',
                              options: FFButtonOptions(
                                width: 100.0,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF19DB8A),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                    ),
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(50.0),
                                disabledColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                disabledTextColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            160.0, 30.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: Color(0xFF19DB8A),
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor: Color(0xFF19DB8A),
                          icon: Icon(
                            Icons.play_arrow,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

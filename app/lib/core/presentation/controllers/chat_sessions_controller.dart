import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/models/chat_session.dart';
import 'assistant_chat_controller.dart';

/// Controlador para manejar múltiples sesiones de chat
class ChatSessionsController extends ChangeNotifier {
  List<ChatSession> _sessions = [];
  ChatSession? _activeSession;
  final AssistantChatController _chatController;

  ChatSessionsController(this._chatController) {
    // Establecer la referencia cruzada
    _chatController.setSessionsController(this);
    // Cargar sesiones al inicializar de forma asíncrona
    _initializeSessions();
  }

  /// Inicializa las sesiones de forma asíncrona
  Future<void> _initializeSessions() async {
    await loadSessions();
  }

  /// Lista de todas las sesiones
  List<ChatSession> get sessions => _sessions;

  /// Sesión activa actual
  ChatSession? get activeSession => _activeSession;

  /// Verifica si hay sesiones
  bool get hasSessions => _sessions.isNotEmpty;

  /// Verifica si hay una sesión activa
  bool get hasActiveSession => _activeSession != null;

  /// Carga las sesiones guardadas
  Future<void> loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getStringList('chat_sessions') ?? [];

      _sessions = sessionsJson
          .map((json) => ChatSession.fromJson(jsonDecode(json)))
          .toList();

      // Activar la última sesión si existe
      if (_sessions.isNotEmpty) {
        _activeSession = _sessions.last;
        _loadActiveSessionMessages();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading chat sessions: $e');
    }
  }

  /// Guarda las sesiones
  Future<void> _saveSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = _sessions
          .map((session) => jsonEncode(session.toJson()))
          .toList();

      await prefs.setStringList('chat_sessions', sessionsJson);
    } catch (e) {
      debugPrint('Error saving chat sessions: $e');
    }
  }

  /// Crea una nueva sesión de chat
  void createNewSession({String title = ''}) {
    final newSession = ChatSession.create(title: title);

    // Marcar todas las sesiones como inactivas
    _sessions = _sessions.map((s) => s.markAsInactive()).toList();

    // Agregar la nueva sesión y marcarla como activa
    _sessions.add(newSession.markAsActive());
    _activeSession = newSession.markAsActive();

    // Limpiar el chat controller
    _chatController.clearChat();

    // Guardar y notificar cambios
    _saveSessions();
    notifyListeners();
  }

  /// Activa una sesión específica
  void activateSession(String sessionId) {
    // Marcar todas las sesiones como inactivas
    _sessions = _sessions.map((s) => s.markAsInactive()).toList();

    // Encontrar y activar la sesión seleccionada
    final sessionIndex = _sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      _sessions[sessionIndex] = _sessions[sessionIndex].markAsActive();
      _activeSession = _sessions[sessionIndex];

      // Cargar los mensajes de la sesión activa
      _loadActiveSessionMessages();

      _saveSessions();
      notifyListeners();
    }
  }

  /// Carga los mensajes de la sesión activa en el chat controller
  void _loadActiveSessionMessages() {
    if (_activeSession != null) {
      _chatController.loadMessages(_activeSession!.messages);
    }
  }

  /// Agrega un mensaje a la sesión activa
  void addMessageToActiveSession(ChatMessage message) {
    if (_activeSession != null) {
      final updatedSession = _activeSession!.withNewMessage(message);

      // Actualizar la sesión en la lista
      final sessionIndex = _sessions.indexWhere(
        (s) => s.id == _activeSession!.id,
      );
      if (sessionIndex != -1) {
        _sessions[sessionIndex] = updatedSession;
        _activeSession = updatedSession;

        _saveSessions();
        notifyListeners();
      }
    }
  }

  /// Elimina una sesión
  void deleteSession(String sessionId) {
    _sessions.removeWhere((s) => s.id == sessionId);

    // Si la sesión eliminada era la activa, activar la última
    if (_activeSession?.id == sessionId) {
      if (_sessions.isNotEmpty) {
        _activeSession = _sessions.last.markAsActive();
        _loadActiveSessionMessages();
      } else {
        _activeSession = null;
        _chatController.clearChat();
      }
    }

    _saveSessions();
    notifyListeners();
  }

  /// Renombra una sesión
  void renameSession(String sessionId, String newTitle) {
    final sessionIndex = _sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      _sessions[sessionIndex] = _sessions[sessionIndex].copyWith(
        title: newTitle,
      );

      // Si es la sesión activa, actualizarla
      if (_activeSession?.id == sessionId) {
        _activeSession = _sessions[sessionIndex];
      }

      _saveSessions();
      notifyListeners();
    }
  }

  /// Limpia todas las sesiones
  void clearAllSessions() {
    _sessions.clear();
    _activeSession = null;
    _chatController.clearChat();

    _saveSessions();
    notifyListeners();
  }

  /// Obtiene el título de una sesión
  String getSessionTitle(String sessionId) {
    final session = _sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => ChatSession.create(title: ''),
    );
    return session.getDisplayTitle();
  }

  /// Obtiene la fecha de la última modificación de una sesión
  DateTime getSessionLastModified(String sessionId) {
    final session = _sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => ChatSession.create(title: ''),
    );
    return session.lastModified;
  }
}

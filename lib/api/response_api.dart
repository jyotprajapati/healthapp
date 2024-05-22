// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

extension ResponseExtensions on Response {
  APIResponse process(String defaultErrorMessage,
      {ResponseHandler handler = const DefaultResponseHandler()}) {
    return handler.handle(this, defaultErrorMessage);
  }

  APIResponse error(
    dynamic error, {
    ResponseHandler handler = const DefaultResponseHandler(),
  }) {
    return handler.error(error);
  }
}

abstract class ResponseHandler {
  APIResponse handle(Response response, String defaultErrorMessage);

  APIResponse error(dynamic error);
}

class DefaultResponseHandler implements ResponseHandler {
  const DefaultResponseHandler();

  @override
  APIResponse handle(Response response, String errorMessage) {
    return DefaultResponseHandler.parse(response, errorMessage);
  }

  static APIResponse parse(Response response, String errorMessage) {
    //
    switch (response.statusCode) {
      case HttpStatus.ok:
        return APIResponse(true, data: response.body);
      case HttpStatus.created:
        return APIResponse(true, data: response.body);
      case HttpStatus.noContent:
        return APIResponse(true, data: response.body);

      case HttpStatus.badRequest:
        return APIResponse(false,
            data: response.body,
            message: handleErrorMessage(
              response.body,
              errorMessage,
              'You are unauthenticated for this action',
            ),
            severity: ErrorLevel.Authentication);
      case HttpStatus.unauthorized:
        return APIResponse(false,
            data: response.body,
            message: handleErrorMessage(
              response.body,
              errorMessage,
              'You are unauthenticated for this action',
            ),
            severity: ErrorLevel.Authentication);
      case HttpStatus.forbidden:
        return APIResponse(false,
            data: response.body,
            message: handleErrorMessage(
              response.body,
              errorMessage,
              'You are unauthenticated for this action',
            ),
            severity: ErrorLevel.Authorization);
      case HttpStatus.notFound:
        return APIResponse(false,
            data: response.body,
            message: handleErrorMessage(
              response.body,
              errorMessage,
              'Invalid request',
            ),
            severity: ErrorLevel.URL);
      case HttpStatus.methodNotAllowed:
        return APIResponse(false,
            data: response.body,
            message: handleErrorMessage(
              response.body,
              errorMessage,
              'Method not allowed',
            ),
            severity: ErrorLevel.URL);
      case HttpStatus.unprocessableEntity:
        return APIResponse(
          false,
          data: response.body,
          message: handleErrorMessage(
            response.body,
            errorMessage,
            'Invalid Data',
          ),
          severity: ErrorLevel.Request,
        );
      case HttpStatus.tooManyRequests:
        return APIResponse(
          false,
          message: handleErrorMessage(
            response.body,
            errorMessage,
            'Too many requests',
          ),
          severity: ErrorLevel.Request,
        );
      case HttpStatus.internalServerError:
        return APIResponse(
          false,
          message: handleErrorMessage(
            response.body,
            errorMessage,
            'Server Error',
          ),
          severity: ErrorLevel.Server,
        );
      default:
        return APIResponse(
          false,
          message: handleErrorMessage(
            response.body,
            errorMessage,
            'Server Error (${response.statusCode}).',
          ),
          severity: ErrorLevel.Unknown,
        );
    }
  }

  @override
  APIResponse error(dynamic error) {
    return APIResponse(
      false,
      message: APIRequestError(error).message,
      severity: ErrorLevel.Connection,
    );
  }
}

class APIRequestError {
  dynamic error;
  late String message;

  APIRequestError(this.error) {
    switch (error.runtimeType) {
      case SocketException:
        message = 'Network Error: could not connect to the server';
        break;
      case ClientException:
        message = 'Network Error: could not connect to the server';
        break;
      default:
        message = 'Error: Something went wrong with the server request.';
        break;
    }
  }
}

class APIResponse {
  ErrorLevel? severity;
  bool ok;
  dynamic data;
  String message;

  APIResponse(this.ok, {this.data, this.message = '', this.severity});
}

enum ErrorLevel {
  Connection,
  Server,
  Authentication,
  Authorization,
  URL,
  Request,
  Unknown
}

String handleErrorMessage(
  dynamic response,
  String defaultMessage,
  String staticMessage,
) {
  if (defaultMessage.isNotEmpty) {
    return defaultMessage;
  } else {
    try {
      String message = (json.decode(response))['message'] ?? "";
      if (message.isNotEmpty) {
        return message;
      } else {
        return staticMessage;
      }
    } catch (e) {
      return staticMessage;
    }
  }
}

import 'package:toodler_kids/domain/entities/entities.dart';
import 'package:toodler_kids/domain/repositories/content_repository.dart';

class LoadManifest {
  LoadManifest(this._repository);
  final ContentRepository _repository;

  Future<ManifestEntity> call() => _repository.loadManifest();
}

class GetZones {
  GetZones(this._repository);
  final ContentRepository _repository;

  Future<List<ZoneEntity>> call() async {
    final manifest = await _repository.loadManifest();
    return manifest.zones;
  }
}

class GetLevelsForGame {
  GetLevelsForGame(this._repository);
  final ContentRepository _repository;

  Future<List<GameLevelEntity>> call(String gameType, {String? zoneId}) {
    return _repository.getLevelsForGame(gameType, zoneId: zoneId);
  }
}

class GetDrawingTemplates {
  GetDrawingTemplates(this._repository);
  final ContentRepository _repository;

  Future<List<DrawingTemplateEntity>> call() => _repository.getDrawingTemplates();
}

class GetFunFacts {
  GetFunFacts(this._repository);
  final ContentRepository _repository;

  Future<List<FunFactEntity>> call() => _repository.getFunFacts();
}

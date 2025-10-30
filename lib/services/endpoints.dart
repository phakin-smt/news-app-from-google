enum NewsEndpoint {
  latest,
  world,
  business,
  technology,
  entertainment,
  sports,
  science,
  health
}

extension Path on NewsEndpoint {
  String get path {
    switch (this) {
      case NewsEndpoint.latest:
        return 'latest';
      case NewsEndpoint.world:
        return 'world';
      case NewsEndpoint.business:
        return 'business';
      case NewsEndpoint.technology:
        return 'technology';
      case NewsEndpoint.entertainment:
        return 'entertainment';
      case NewsEndpoint.sports:
        return 'sports';
      case NewsEndpoint.science:
        return 'science';
      case NewsEndpoint.health:
        return 'health';

      default:
        return 'latest';
    }
  }
}

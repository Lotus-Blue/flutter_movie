class ActorRecommendation {
  String actorId;
  String description;

  ActorRecommendation(this.actorId, this.description);

  ActorRecommendation.fromJson(Map data) {
    actorId = data['actorId'];
    description = data['description'];
  }
}

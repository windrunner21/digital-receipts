class CampaignsList {
  final List<Campaigns> campaigns;

  CampaignsList({
    this.campaigns,
  });

  factory CampaignsList.fromJson(List<dynamic> parsedJson) {
    List<Campaigns> campaigns = new List<Campaigns>();
    campaigns = parsedJson.map((i) => Campaigns.fromJson(i)).toList();

    return new CampaignsList(campaigns: campaigns);
  }
}

class Campaigns {
  final String id;
  final String campaignName;
  final String storeName;
  final String category;
  final String description;
  final String startDate;
  final String endDate;
  final String details;

  Campaigns(
      {this.id,
      this.campaignName,
      this.category,
      this.storeName,
      this.description,
      this.startDate,
      this.endDate,
      this.details});

  factory Campaigns.fromJson(Map<String, dynamic> json) {
    return new Campaigns(
        id: json['_id'],
        campaignName: json['campaignName'],
        storeName: json['storeName'],
        category: json['campaignCategory'],
        description: json['description'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        details: json['details']);
  }
}

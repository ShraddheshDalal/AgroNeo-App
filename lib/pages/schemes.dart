import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SchemesPage extends StatefulWidget {
  const SchemesPage({super.key});
  final String routeSc = '/schemes';

  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  final List<Map<String, dynamic>> schemes = [
    {
      "name": "PM-Kisan Samman Nidhi (PM-KISAN)",
      "description": "Provides ₹6,000 per year in three equal installments to small and marginal farmers. It helps them meet their agricultural and household needs.",
      "link": "https://pmkisan.gov.in/",
      "icon": Icons.agriculture,
      "isExpanded": false
    },
    {
      "name": "Pradhan Mantri Fasal Bima Yojana (PMFBY)",
      "description": "Crop insurance scheme to protect farmers against crop failure due to natural calamities, pests, and diseases. Farmers pay low premium rates.",
      "link": "https://pmfby.gov.in/",
      "icon": Icons.security,
      "isExpanded": false
    },
    {
      "name": "Soil Health Card Scheme",
      "description": "Provides farmers with soil health cards to help understand the nutrient status of their soil and get crop-wise recommendations for fertilizers.",
      "link": "https://soilhealth.dac.gov.in/",
      "icon": Icons.spa,
      "isExpanded": false
    },
    {
      "name": "Kisan Credit Card (KCC)",
      "description": "Offers timely and affordable credit to farmers for crops, post-harvest expenses, and personal consumption. Includes interest subvention benefits.",
      "link": "https://dfccbank.com/kisan-credit-card",
      "icon": Icons.credit_card,
      "isExpanded": false
    },
    {
      "name": "Paramparagat Krishi Vikas Yojana (PKVY)",
      "description": "Promotes organic farming through adoption of organic villages and clusters. Focuses on sustainable practices and organic value chains.",
      "link": "https://pgsindia-ncof.gov.in/pkvy/index.aspx",
      "icon": Icons.eco,
      "isExpanded": false
    },
    {
      "name": "e-NAM (National Agriculture Market)",
      "description": "Online trading platform for agricultural commodities to ensure better price discovery and transparency in agri-markets across India.",
      "link": "https://enam.gov.in/web/",
      "icon": Icons.shopping_cart,
      "isExpanded": false
    },
    {
      "name": "Rashtriya Krishi Vikas Yojana (RKVY-RAFTAAR)",
      "description": "Provides financial support to states for agriculture development projects and startups in agri-business. Focus on innovation and entrepreneurship.",
      "link": "https://rkvy.nic.in/",
      "icon": Icons.business,
      "isExpanded": false
    },
    {
      "name": "National Mission on Sustainable Agriculture (NMSA)",
      "description": "Promotes sustainable agriculture through efficient use of resources, climate-resilient practices, and integrated farming systems.",
      "link": "https://nmsa.dac.gov.in/",
      "icon": Icons.nature,
      "isExpanded": false
    },
    {
      "name": "Pradhan Mantri Krishi Sinchai Yojana (PMKSY)",
      "description": "Aims to expand irrigation coverage and improve water use efficiency through 'More Crop per Drop' strategy.",
      "link": "https://pmksy.gov.in/",
      "icon": Icons.water_drop,
      "isExpanded": false
    },
    {
      "name": "Agri-Clinics and Agri-Business Centres Scheme (ACABC)",
      "description": "Encourages agriculture graduates to establish agri-clinics and agri-business centers to provide expert services to farmers.",
      "link": "https://www.acabcmis.gov.in/",
      "icon": Icons.local_hospital,
      "isExpanded": false
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Government Schemes for Farmers', 
          style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: schemes.length,
          itemBuilder: (context, index) {
            return SchemeCard(
              scheme: schemes[index],
              onToggleExpand: () {
                setState(() {
                  schemes[index]['isExpanded'] = !schemes[index]['isExpanded'];
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class SchemeCard extends StatelessWidget {
  final Map<String, dynamic> scheme;
  final VoidCallback onToggleExpand;

  const SchemeCard({
    super.key,
    required this.scheme,
    required this.onToggleExpand,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      scheme['icon'],
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      scheme['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    scheme['isExpanded'] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (scheme['isExpanded'])
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      scheme['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _launchURL(scheme['link']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply Now'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
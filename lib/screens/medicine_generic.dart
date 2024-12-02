import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantity_input/quantity_input.dart';

class MedicineAlternativesScreen extends StatefulWidget {
  @override
  _MedicineAlternativesScreenState createState() =>
      _MedicineAlternativesScreenState();
}

class _MedicineAlternativesScreenState extends State<MedicineAlternativesScreen> {
  final List<Map<String, dynamic>> medicineData = [
      {"brand_name": "Acetaminophen", "generic_alternatives": ["Paracetamol"]},
    {"brand_name": "Panadol", "generic_alternatives": ["Paracetamol"]},
    {"brand_name": "Prilosec", "generic_alternatives": ["Omeprazole"]},
    {"brand_name": "Amoxil", "generic_alternatives": ["Amoxicillin"]},
    {"brand_name": "Lipitor", "generic_alternatives": ["Atorvastatin"]},
    {"brand_name": "Zyrtec", "generic_alternatives": ["Cetirizine"]},
    {"brand_name": "Motrin", "generic_alternatives": ["Ibuprofen"]},
    {"brand_name": "Advil", "generic_alternatives": ["Ibuprofen"]},
    {"brand_name": "Aleve", "generic_alternatives": ["Naproxen"]},
    {"brand_name": "Disprin", "generic_alternatives": ["Aspirin"]},
    {"brand_name": "Aspro clear", "generic_alternatives": ["Aspirin"]},
    {"brand_name": "Glucophage", "generic_alternatives": ["Metformin"]},
    {"brand_name": "Synthroid", "generic_alternatives": ["Levothyroxine"]},
    {"brand_name": "Prinivil", "generic_alternatives": ["Lisinopril"]},
    {"brand_name": "Zestril", "generic_alternatives": ["Lisinopril"]},
    {"brand_name": "Norvasc", "generic_alternatives": ["Amlodipine"]},
    {"brand_name": "Cozaar", "generic_alternatives": ["Losartan"]},
    {"brand_name": "GenericHydrochlorothiazide", "generic_alternatives": ["Hydrochlorothiazide"]},
    {"brand_name": "Zocor", "generic_alternatives": ["Simvastatin"]},
    {"brand_name": "Flonase", "generic_alternatives": ["Fluticasone Propionate"]},
    {"brand_name": "Singulair", "generic_alternatives": ["Montelukast"]},
    {"brand_name": "Ventolin", "generic_alternatives": ["Albuterol"]},
    {"brand_name": "Proventil", "generic_alternatives": ["Albuterol"]},
    {"brand_name": "Prilosec", "generic_alternatives": ["Omeprazole"]},
    {"brand_name": "Prevacid", "generic_alternatives": ["Lansoprazole"]},
    {"brand_name": "Protonix", "generic_alternatives": ["Pantoprazole"]},
    {"brand_name": "Zantac", "generic_alternatives": ["Ranitidine"]},
    {"brand_name": "Tagamet", "generic_alternatives": ["Cimetidine"]},
    {"brand_name": "Claritin", "generic_alternatives": ["Loratadine"]},
    {"brand_name": "Benadryl", "generic_alternatives": ["Diphenhydramine"]},
    {"brand_name": "Imodium", "generic_alternatives": ["Loperamide"]},
    {"brand_name": "Dulcolax", "generic_alternatives": ["Bisacodyl"]},
    {"brand_name": "Senokot", "generic_alternatives": ["Sennosides"]},
    {"brand_name": "Colace", "generic_alternatives": ["Docusate Sodium"]},
    {"brand_name": "GenericMelatonin", "generic_alternatives": ["Melatonin"]},
    {"brand_name": "Valium", "generic_alternatives": ["Diazepam"]},
    {"brand_name": "Xanax", "generic_alternatives": ["Alprazolam"]},
    {"brand_name": "Ativan", "generic_alternatives": ["Lorazepam"]},
    {"brand_name": "Zoloft", "generic_alternatives": ["Sertraline"]},
    {"brand_name": "Prozac", "generic_alternatives": ["Fluoxetine"]},
    {"brand_name": "Celexa", "generic_alternatives": ["Citalopram"]},
    {"brand_name": "Crestor", "generic_alternatives": ["Rosuvastatin"]},
    {"brand_name": "Synthroid", "generic_alternatives": ["Levothyroxine"]},
    {"brand_name": "Nexium", "generic_alternatives": ["Esomeprazole"]},
    {"brand_name": "Ventolin HFA", "generic_alternatives": ["Albuterol"]},
    {"brand_name": "Advair Diskus", "generic_alternatives": ["Fluticasone propionate/Salmeterol"]},
    {"brand_name": "Lantus Solostar", "generic_alternatives": ["Glargine insulin"]},
    {"brand_name": "Vyvanse", "generic_alternatives": ["Lisdexamfetamine"]},
    {"brand_name": "Lyrica", "generic_alternatives": ["Pregabalin"]},
    {"brand_name": "Spiriva Handihaler", "generic_alternatives": ["Tiotropium bromide"]},
    {"brand_name": "Diovan", "generic_alternatives": ["Valsartan"]},
    {"brand_name": "Lantus", "generic_alternatives": ["Glargine insulin"]},
    {"brand_name": "Januvia", "generic_alternatives": ["Sitagliptin"]},
    {"brand_name": "Abilify", "generic_alternatives": ["Aripiprazole"]},
    {"brand_name": "Celebrex", "generic_alternatives": ["Celecoxib"]},
    {"brand_name": "Cialis", "generic_alternatives": ["Tadalafil"]},
    {"brand_name": "Viagra", "generic_alternatives": ["Sildenafil"]},
    {"brand_name": "Symbicort", "generic_alternatives": ["Budesonide/Formoterol"]},
    {"brand_name": "Zetia", "generic_alternatives": ["Ezetimibe"]},
    {"brand_name": "Nasonex", "generic_alternatives": ["Mometasone furoate"]},
    {"brand_name": "Suboxone", "generic_alternatives": ["Buprenorphine/Naloxone"]},
    {"brand_name": "Namenda", "generic_alternatives": ["Memantine"]},
    {"brand_name": "Bystolic", "generic_alternatives": ["Nebivolol"]},
    {"brand_name": "Levemir", "generic_alternatives": ["Detemir insulin"]},
    {"brand_name": "Xarelto", "generic_alternatives": ["Rivaroxaban"]},
    {"brand_name": "Flovent HFA", "generic_alternatives": ["Fluticasone propionate"]},
    {"brand_name": "Oxycontin", "generic_alternatives": ["Oxycodone"]},
    {"brand_name": "Cymbalta", "generic_alternatives": ["Duloxetine"]},
    {"brand_name": "Nuvaring", "generic_alternatives": ["Etonogestrel vaginal ring"]},
    {"brand_name": "Thyroid", "generic_alternatives": ["Levothyroxine"]},
    {"brand_name": "Voltaren Gel", "generic_alternatives": ["Diclofenac gel"]},
    {"brand_name": "Dexilant", "generic_alternatives": ["Dexlansoprazole"]},
    {"brand_name": "Benicar", "generic_alternatives": ["Benazapril"]},
    {"brand_name": "Proventil HFA", "generic_alternatives": ["Albuterol"]},
    {"brand_name": "Tamiflu", "generic_alternatives": ["Oseltamivir"]},
    {"brand_name": "Novolog Flexpen", "generic_alternatives": ["Insulin aspart"]},
    {"brand_name": "Humalog", "generic_alternatives": ["Insulin lispro"]},
    {"brand_name": "Novolog", "generic_alternatives": ["Insulin aspart"]},
    {"brand_name": "Premarin", "generic_alternatives": ["Conjugated estrogens"]},
    {"brand_name": "Vesicare", "generic_alternatives": ["Solifenacin succinate"]},
    {"brand_name": "Benicar HCT", "generic_alternatives": ["Benazapril/Hydrochlorothiazide"]},
    {"brand_name": "Afluria", "generic_alternatives": ["Oseltamivir phosphate"]},
    {"brand_name": "Lumigan", "generic_alternatives": ["Brimonidine tartrate"]},
    {"brand_name": "Lo Loestrin Fe", "generic_alternatives": ["Norethindrone/Ethinyl estradiol/Ferrous fumarate"]},
    {"brand_name": "Janumet", "generic_alternatives": ["Sitagliptin/Metformin"]},
    {"brand_name": "Ortho-Tri-Cyclen Lo 28", "generic_alternatives": ["Norgestimate/Ethinyl estradiol"]},
    {"brand_name": "Combivent Respimat", "generic_alternatives": ["Ipratropium bromide/Albuterol"]},
    {"brand_name": "Toprol-XL", "generic_alternatives": ["Metoprolol succinate"]},
    {"brand_name": "Pristiq", "generic_alternatives": ["Desvenlafaxine succinate"]},
    {"brand_name": "Travatan Z", "generic_alternatives": ["Travoprost"]},
    {"brand_name": "Pataday", "generic_alternatives": ["Olopatadine hydrochloride"]},
    {"brand_name": "Humalog Kwikpen", "generic_alternatives": ["Insulin lispro"]},
    {"brand_name": "Vytorin", "generic_alternatives": ["Ezetimibe/Simvastatin"]},
    {"brand_name": "Minastrin 24 Fe", "generic_alternatives": ["Norethindrone/Ethinyl estradiol/Ferrous fumarate"]},
    {"brand_name": "Focalin XR", "generic_alternatives": ["Dexmethylphenidate hydrochloride"]},
    {"brand_name": "Avodart", "generic_alternatives": ["Dutasteride"]},
    {"brand_name": "Seroquel XR", "generic_alternatives": ["Quetiapine fumarate"]},
    {"brand_name": "Strattera", "generic_alternatives": ["Atomoxetine hydrochloride"]},
    {"brand_name": "Pradaxa", "generic_alternatives": ["Dabigatran etexilate"]},
    {"brand_name": "Chantix", "generic_alternatives": ["Varenicline"]},
    {"brand_name": "Zostavax", "generic_alternatives": ["Zoster live vaccine"]},
    {"brand_name": "Namenda XR", "generic_alternatives": ["Memantine hydrochloride"]},
    {"brand_name": "Humira", "generic_alternatives": ["Adalimumab"]},
    {"brand_name": "Dulera", "generic_alternatives": ["Budesonide/Formoterol"]},
    {"brand_name": "Victoza 3-Pak", "generic_alternatives": ["Liraglutide"]},
    {"brand_name": "Lunesta", "generic_alternatives": ["Eszopiclone"]},
    {"brand_name": "Exelon", "generic_alternatives": ["Rivastigmine"]},
    {"brand_name": "Combigan", "generic_alternatives": ["Brimonidine tartrate,Timolol maleate"]},
    {"brand_name": "Onglyza", "generic_alternatives": ["Saxagliptin"]},
    {"brand_name": "Exforge", "generic_alternatives": ["Valsartan","Amlodipine"]},
    {"brand_name": "Welchol", "generic_alternatives": ["Colesevelam"]},
    {"brand_name": "Premarin Vaginal", "generic_alternatives": ["Conjugated estrogens Vaginal cream"]},
    {"brand_name": "Enbrel", "generic_alternatives": ["Etanercept"]},
    {"brand_name": "Ranexa", "generic_alternatives": ["Ranolazine"]},
    {"brand_name": "Invokana", "generic_alternatives": ["Canagliflozin"]},
    {"brand_name": "Evista", "generic_alternatives": ["Raloxifene"]},
    {"brand_name": "Truvada", "generic_alternatives": ["Emtricitabine","Tenofovir disoproxil fumarate"]},
    {"brand_name": "Tradjenta", "generic_alternatives": ["Linagliptin"]},
    {"brand_name": "Alphagan P", "generic_alternatives": ["Brimonidine tartrate"]},
    {"brand_name": "Viibryd", "generic_alternatives": ["Vilazodone"]},
    {"brand_name": "Effient", "generic_alternatives": ["Prasugrel"]},
    {"brand_name": "Xopenex HFA", "generic_alternatives": ["Levalbuterol"]},
    {"brand_name": "Azor", "generic_alternatives": ["Olmesartan medoxomil/Amlodipine"]},
    {"brand_name": "Norvir", "generic_alternatives": ["Ritonavir"]},
    {"brand_name": "Amitiza", "generic_alternatives": ["Cibrotraxin"]},
    {"brand_name": "Latuda", "generic_alternatives": ["Lurasidone"]},
    {"brand_name": "Lotemax", "generic_alternatives": ["Loteprednol etabonate"]},
    {"brand_name": "Advair HFA", "generic_alternatives": ["Fluticasone propionate/Salmeterol"]}, {'brand_name': 'Citalopram', 'generic_alternatives': ['GenericCitalopram', 'Celexa']}

  ];

  final TextEditingController _searchController = TextEditingController();
  List<String> _genericAlternatives = [];
  String _selectedGeneric = '';
  int _quantity = 1;
  bool _showPlaceOrder = false;

  // Initialize Firebase and Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _genericAlternatives = medicineData
          .where((medicine) =>
              medicine["brand_name"].toLowerCase().contains(query))
          .expand((medicine) => List<String>.from(medicine["generic_alternatives"]))
          .toSet()
          .toList();
      _selectedGeneric = _genericAlternatives.isNotEmpty
          ? _genericAlternatives.first
          : '';
      _showPlaceOrder = _selectedGeneric.isNotEmpty;
    });
  }

  Future<void> _placeOrder() async {
  try {
    await _firestore.collection('orders').add({
      'genericName': _selectedGeneric,
      'quantity': _quantity,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final snackBar = SnackBar(
      content: Text('Order placed for $_quantity of $_selectedGeneric'),
      duration: Duration(seconds: 2),
      backgroundColor: const Color(0xFF4CAF50),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navigate to the order history screen after the order is placed
    _navigateToOrderHistory();
  } catch (e) {
    print('Error placing order: $e');
    final snackBar = SnackBar(
      content: Text('Failed to place order. Please try again.'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void _navigateToOrderHistory() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:  AppBar(
        title: Text('Medicine Search', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _navigateToOrderHistory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Enter Brand Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // No need for a separate search function
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_genericAlternatives.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generic Alternatives:',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: _genericAlternatives
                            .map((generic) => ChoiceChip(
                                  label: Text(generic),
                                  selected: _selectedGeneric == generic,
                                  onSelected: (isSelected) {
                                    setState(() {
                                      _selectedGeneric = isSelected ? generic : '';
                                      _showPlaceOrder = isSelected;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      if (_showPlaceOrder)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text('Quantity: '),
                                QuantityInput(
                                  value: _quantity,
                                  onChanged: (value) {
                                    setState(() {
                                      _quantity = int.parse(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _placeOrder,
                              child: Text(
                                'Place Order',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _searchController.clear();
          setState(() {
            _genericAlternatives = [];
            _selectedGeneric = '';
            _quantity = 1;
            _showPlaceOrder = false;
          });
        },
        child: Icon(Icons.clear),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }
}

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    try {
      final snapshot = await _firestore.collection('orders').get();
      setState(() {
        _orders = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching order history: $e');
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    var format = DateFormat('yyyy-MM-dd');
    return format.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: _orders.isEmpty
          ? Center(
              child: Text(
                'No orders found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generic Name: ${order['genericName']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Quantity: ${order['quantity']}'),
                        SizedBox(height: 8),
                        
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
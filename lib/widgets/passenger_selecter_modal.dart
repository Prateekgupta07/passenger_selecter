import 'package:flutter/material.dart';
import '../utils/vehicle_data.dart';

class PassengerSelectorModal extends StatefulWidget {
  @override
  _PassengerSelectorModalState createState() => _PassengerSelectorModalState();
}

class _PassengerSelectorModalState extends State<PassengerSelectorModal> {
  int passengerCount = 1;

  late PageController imagePageController;
  late PageController namePageController;
  late PageController pricePageController;

  @override
  void initState() {
    super.initState();
    imagePageController = PageController();
    namePageController = PageController();
    pricePageController = PageController();
  }

  @override
  void dispose() {
    imagePageController.dispose();
    namePageController.dispose();
    pricePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        _buildDivider(),
        _buildVehicleSelector(),
        SizedBox(height: 16.0),
        _buildPassengerControls(),
        SizedBox(height: 16.0),
        _buildDivider(),
        _buildPaymentMethod(),
        SizedBox(height: 24.0),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Text(
        'Number of Passengers',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withOpacity(0.5),
      thickness: 1,
      height: 32,
    );
  }

  Widget _buildVehicleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 168,
          width: 265,
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: imagePageController,
            itemCount: vehicleImage.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int itemIndex) {
              return Image.asset(
                vehicleImage[itemIndex],
                width: 265,
                height: 168,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildVehicleInfo(),
          _buildPassengerCountControls(),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: 90,
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: namePageController,
            itemCount: vehicleName.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int itemIndex) {
              return Text(
                vehicleName[itemIndex],
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              );
            },
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 20,
          width: 90,
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: pricePageController,
            itemCount: vehiclePrice.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int itemIndex) {
              return Text(
                '\$${vehiclePrice[itemIndex]}',
                style: TextStyle(fontSize: 17.0, color: Colors.black),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerCountControls() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            passengerCount > 1 ? Icon(Icons.people) : Icon(Icons.person),
            Text(
              '$passengerCount',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 20),
        _buildCountAdjustButtons(),
      ],
    );
  }


  Widget _buildCountAdjustButtons() {
    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          children: [
            _buildCountButton(Icons.remove, _decrementPassengerCount, "Remove"),
            SizedBox(width: 32.0),
            Text(
              '$passengerCount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 32.0),
            _buildCountButton(Icons.add, _incrementPassengerCount, "Add"),
          ],
        ),
      ),
    );
  }

  Widget _buildCountButton(IconData icon, VoidCallback onPressed, String iconType) {
    return
      iconType=="Add"?IconButton(
        padding: EdgeInsets.zero,
        iconSize: 32,
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ):
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.7),
        ),
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 32,
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
      );
  }

  void _decrementPassengerCount() {
    if (passengerCount > 1) {
      setState(() {
        passengerCount--;
      });
      _navigatePages(imagePageController.previousPage);
      _navigatePages(namePageController.previousPage);
      _navigatePages(pricePageController.previousPage);
    }
  }

  void _incrementPassengerCount() {
    if (passengerCount < 4) {
      setState(() {
        passengerCount++;
      });
      _navigatePages(imagePageController.nextPage);
      _navigatePages(namePageController.nextPage);
      _navigatePages(pricePageController.nextPage);
    }
  }

  void _navigatePages(Function({required Duration duration, required Curve curve}) navigate) {
    navigate(duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  Widget _buildPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/cash_icon.png',
                  width: 53,
                  height: 32,
                ),
                SizedBox(width: 12),
                Text(
                  'Cash',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 500),
            child: Text(
              'Choose ${vehicleName[passengerCount - 1]}',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

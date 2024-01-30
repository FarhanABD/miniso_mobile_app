import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerOrderModel extends StatelessWidget {
  final dynamic order;
  const CustomerOrderModel({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent.shade200),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(order['orderimage']),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['ordername'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(('\$') +
                              (order['orderprice'].toStringAsFixed(2))),
                          Text((' x ') + (order['orderqty'].toString())),
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('See More'), Text(order['deliverystatus'])],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: order['deliverystatus'] == 'delivered'
                      ? Colors.pink.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //----- MENAMPILKAN NAMA USER PADA HALAMAN CUSTOMER ORDER -------//
                    Text(
                      ('Name: ') + (order['custname']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    //----- MENAMPILKAN PHONE USER PADA HALAMAN CUSTOMER ORDER -------//
                    Text(
                      ('Phone: ') + (order['phone']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    //----- MENAMPILKAN EMAIL USER PADA HALAMAN CUSTOMER ORDER -------//
                    Text(
                      ('Email: ') + (order['email']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    //----- MENAMPILKAN ALAMAT USER PADA HALAMAN CUSTOMER ORDER -------//
                    Text(
                      ('Address: ') + (order['address']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    //----- MENAMPILKAN STATUS PAYMENT USER PADA HALAMAN CUSTOMER ORDER -------//
                    Row(
                      children: [
                        const Text(
                          ('Payment Status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (order['paymentstatus']),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.redAccent),
                        ),
                      ],
                    ),
                    //----- MENAMPILKAN DELIVERY STATUS USER PADA HALAMAN CUSTOMER ORDER -------//
                    Row(
                      children: [
                        const Text(
                          ('delivery Status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          (order['deliverystatus']),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.redAccent),
                        ),
                      ],
                    ),
                    order['deliverystatus'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery Date: ') +
                                (DateFormat('yyyy-MM-dd')
                                        .format(order['deliverydate'].toDate()))
                                    .toString(),
                            style: const TextStyle(fontSize: 15))
                        : const Text(''),
                    order['deliverystatus'] == 'delivered' &&
                            order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {}, child: const Text('Write Review'))
                        : const Text(''),
                    order['deliverystatus'] == 'delivered' &&
                            order['orderreview'] == true
                        ? const Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.red,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          )
                        : const Text('')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

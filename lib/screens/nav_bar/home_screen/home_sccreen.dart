import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      'Mehandi Design',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff472121)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  height: 180.h,
                  child: CarouselSlider(
                      items: [
                        SizedBox(
                          height: 200.h,
                          width: 200.w,
                          child: const Card(
                            child: Center(
                              child: Text(
                                '1',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '2',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          '3',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          '4',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          '5',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        onPageChanged: (index, reason) {
                          print(index);
                        },
                        scrollDirection: Axis.horizontal,
                      )),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff472121)),
                    ),
                  ),
                  Text(
                    'see all',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff472121)),
                  ),
                ],
              ),
              SizedBox(
                width: 1.sw,
                height: 120.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, index) {
                      return SizedBox(
                        height: 120.h,
                        width: 120.w,
                        child: Card(
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      'Popular',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff472121)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 1.sw,
                height: 120.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, index) {
                      return SizedBox(
                        height: 120.h,
                        width: 120.w,
                        child: Card(
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

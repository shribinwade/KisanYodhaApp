import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/CropPriceForeCasting/cropForeCastingCalculator.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CropForeCastingScreen extends StatefulWidget {
  const CropForeCastingScreen({super.key});

  @override
  State<CropForeCastingScreen> createState() => _CropForeCastingScreenState();
}

class _CropForeCastingScreenState extends State<CropForeCastingScreen> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crop Price Forecasting'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text(_error))
                : Center(
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        width: ScreenUtility.screenWidth,
                        height: ScreenUtility.screenHeight,
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Crop Price Forecasting",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          16, // Adjust the font size as needed
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                      width: ScreenUtility
                                          .screenWidth, // Set custom width
                                      height: 50, // Set custom height

                                      child: ListView(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  width: ScreenUtility
                                                          .screenHeight *
                                                      0.5,
                                                  child: const Text(
                                                    'Kharif',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  width: ScreenUtility
                                                          .screenHeight *
                                                      0.5,
                                                  child: const Text(
                                                    'Maharashtra',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xffdcfce7),
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CropForeCastingCalculatorScreen()));
                                    },
                                    child: const Text(
                                        "Price forcasting calculator",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: ScreenUtility.screenHeight * 0.6,
                                    width: ScreenUtility
                                        .screenWidth, // Take remaining height of device
                                    child: CustomScrollView(
                                      slivers: <Widget>[
                                        SliverPadding(
                                            padding: const EdgeInsets.all(1),
                                            sliver: SliverGrid.count(
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              crossAxisCount: 3,
                                              children: <Widget>[
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/a0d3/4f03/727051edd7312f4a5f8679b1d095d2fe?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Ix4SbELi1Wvz-EZbe4wBBPBz~zvmYdl~26gf0RHoHGTm08Ds4P9UjIBqk52EPfc960m9Kd2odOpXVR63tA~77U36yn91kXK~9tS6xoIoYKQKpxWOgetSzGEm3t3K1KvgIhm~0ZqzKwkpDBgil8cTQRvGXCdvGssxVyp3qVt-MnNTwBm3~7B-oeBpfoxiy510Pttcz2glL5Owu8VHNEqaCAz~dgaxs3tAMZOdhAUCVX0EffzLBWtTVJ390rbV~J2eOBuzYgtI2gvfPUcbEz0hLgQ87dtfSNXM5i--qgyBNnZDdQDRZEjaj2Oo0xmXPNH7YxZAFHOmKx-T7WPKJW36cQ__'),
                                                ),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.25),
                                                          blurRadius: 8,
                                                          spreadRadius: -2,
                                                          offset: Offset(
                                                            0,
                                                            4,
                                                          ),
                                                        ),
                                                        BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    9,
                                                                    30,
                                                                    66,
                                                                    0.08),
                                                            blurRadius: 0,
                                                            spreadRadius: 1),
                                                      ],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Image.network(
                                                        'https://s3-alpha-sig.figma.com/img/1442/4b1b/9586ea0d77da6ac003a7d9d974ebb633?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=d834A5-NSfrxT6a83BfrOBP85njqPvuVJaTzKXGH6xAztyblEiplgu-qfcXhbHMniZ7~6eIEhskyplZ5FA3bKsm2ScVjmdIPJ1l1o4unZ3JWQM0eoP11DMY7O5oUAHV~dg0sTjNSlpMB4dND0k-XfORvBSRm2nc99ey5uoLjUnjCfeaHFPKSd66Mi~iIx7Gr8bJIsqX~po1NZArKVOYOZImaz~iPJ~z2SB7YVTjSR43nax-hGOmeez8wAKhGQIccT7AFf2ie6nYArctEoF5ZxpBW2IvXjL-OtLhi4-3TRhf-7lBetfAXYPhaXFhifD6goSkkdr46Eusxn60W2MaGMQ__')),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/ca96/30e8/558cf7a8181b24b81113bfb7cdc64ed7?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=IV1hJh6eB3-mAY3yNwhVQUenPktw5gjKkzhjDntS~A89GB9JZWTaU0h1sL-4m57jy6PWlywRnJTDCRil5lAm7UgWuCwY2xcFa5mMKi7bU5cmo2A1I4LtTCkfPqZlKcbs0SjDXDmteqWEXex1edOgt-3Ux~cujuqJZKudRERBOPiQyMOa45XikX8viwuKSQ4TQIqrD2haP5lLgzZEGPYQNWc9Bli5PZqKbKrM49PWls4dWphomQ5fT~7bVQ56LUBIJxCwxiLvT1gLMcRUfvXa8YLQq7roQp4gcUZG6Yic3ysGGnNXcBF70ji7ML~UpESrCFO8e6i0fBdUHhhmBebecg__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/850e/c8b4/b57359ce315c3b2c3e88c72d216d42fb?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=GxD3c4t~Qppw8r8hnUZWTYVW6LBU4lmFj2KIWsQdKNicla2a-uzgnDfWmFjNC3uaUup~bWnZU9eJ5QHIZHuePn2rq6ryXzhoemKqfruxKyBTkFn5OCDYj-4Zl3zIzvYFxlmsmipRnp4PUSYNF8TTscgoYLUeFVfMs0h8lWwVjFht42OCQoBKHZoqlElDJvqdJgL7Qs4okztFYjSA74HhvAANCBVMbQ38V1fXmVFA4O06LQLXSonoA5EX7azYTn10p1emH4cwU4Tiv~SFy9Bfn0RlSvYFQ1LcEoG3ayNnLxeZTjX42AYVsoU-7uTUgwqpgplJABkJhnxkqUhxEsD8~Q__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/2413/7006/c64a2e4d0a0b709e168a46d264092ea3?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=TU-hb56rI79lTSOd4GMc7CLOHFuXaA29-A6abJ8Yhq8CPuLmagelsz7rGGFSndH5gFPsw8YswEOCwrSer0pnBc4c3c2n10r6vHzQavk-DE4PQrARQYDvr-ZFpxwaNUvAPdtzFkjI-9xuiKFaK3Dxd2JiCrZ3659NrFW-WrED4IoH5W7K6Cx8kV3U4MYP3eADz45~bJo~~P7SXmB10Jo1XiiCvDTL4kJC9WybwtUZJY9SKSavQGH0OauoEA1dqLRT9~cgKRK6XysNdbXuVI5gL-D3bAByzObNal~goC8bICSemQ-HcsZ8it41l41BtWreyonaQezeQXtXsQcx9wrvsw__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/2c82/6ef7/1c04681022bea1823bdf7c93e8da73cd?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=OPo4NB82BL4jHk6ChaaUPEgE5sdqswp6sPhR7TBZeIHVhc6IFk5-2MU~fAdSdkS1wbfIZttGyDq6YBlNcyyYG96wZIGqmr02f7URjlX-S-7eJCfSKM3Jhfr6TGwV9URsQP07xty46wyH6~x-Skz-eGKSi~M9dGwgoaDCOHpxqNEgWqfD3DXMkcsmjXnuyAZnwu6sbhYvbAar2R-HS-iLq3toCgnkgmsgUVe5yO9Zf-22-mVfLZ-5CuZ54sjyI2ct86GlqZT6hP-tI7S0y3UZ2gLE1c3i26TfmZsBbNB7iPu-rEC6Il~CYEYOGnPFBw4TqPF8-0xSwP2OyYvkPuaXHA__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/37b8/7dc7/12161805a2f56eb7629abc06a60df163?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=irYpiAnG~bloCw~-zKvSjVsVC5A7dXXn1MXL-vwWkgk3M4ZKzL~Mac-tQ7FUSjZhLWV0~D4AXM5dihS3iOFiz5F-GYo8lGzgUYoAAekoqjtptONt8Qvsm5fHseJkI~dPwHl1haoZAKrG9E5f5eePYYbSiohBu6mvCPtjmq7HtiuLJxmec662GUI9RjP4ET-~cIPlYTIxD-q-QCkqJfv42H5D1BIXezQp9PVk3Hhkzu8OlnR~o1y~dWxd6kklK5GlmIhZrj4B7rP7oJFIeB5O8a5erl2f6~1J5A-BHhryG0EaodT5d7kMnJ8rA6xQvuP~QCs9Y7pJQJrX2B-jj7jDRg__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/8cc2/aa63/f9d4acab5aa5f9cdd8f669084ba48b45?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=r01ZxMIgrkWHoJW8keBjRM0QSLe6Z4WozeV3xqMRqbUWD~BOs-io7XxbvujL9iuRasuFT35h03d1jRXEM4vbGN0Lmqgll2gu3pw9BBtj2DSJHB9FpntlhPXJADYTOrt-Ry5wc3rsA8YhJsJqynh2K61ZkFhLkgZiUqFXJQeuLOuXtIMk~UdMW7j2KJqzrsCnRbTk7qJkdoXL6PQFmuw408RmSO5of1UK7~hS3ZigCbFuzpoBnFWfqpJkTFeSGxUl29K-LpV4FRi5O~TZIv5DPzbzNlZTR3H7mzVbL5x8MM3DxHiEx-DR3jytsYtOB6F0jhzvtpA7k1pQzTYmd-uXoA__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/6a18/0c34/72c6363c27046dcd41c92ddc1d452944?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=EZ67YQxyBFH1ngWpWYsCIAw3hVAR4MO0lDtqjGyOFpf92rfzOnDGYFdyWBh6VbrPDEO0tp7-ruYDZqt~~X9v16lgTcjo1a6hekz4FYRl7yXWnBGknhJyNSg-yupmlAYu6MxldNjjhdVc6M8DINNP1oduakHX7A-ROivHMbUe-k8swSUGYme8QIs5OFi~lgwd2BFywoYCuHgc~W0cDrGD1leLwGDrjfv2R9PnlZ5TmuTMX-pUdXWrlw1TJMrDiFaxOT7TEHfhFOZpj-yiedu4yOvj4zYdh9kjrU0l628SiKOCaC0Ooplf~GRtR3drEYh7JnOp3r9SG9FTMkBUNMlW9Q__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/b09d/91fa/9efa21098ae27828228c84c2b685786f?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=PKO8VUfw04WTXyp9o-DO9qy2rMaHGMVBfxmP5Vh~QCZrNZKzJAzCISXfaFP~5dJlTGHKUbluS09T2nl~TFDvg8jCiAgLX3TWsN4W6KhkDdjwn6PCA47mXZiWsfy~FotJ0qlFZ8SiT3dMVDFfvO8IZpiu8T7nuFTPqdcywKIckn6eS3q71kzPFlYdjhKSo4NjOXOzFln9ce0eZ7~euXtsDn3xjNmMZJhrgodUTNzLsK~aSnqs80bfiiB-OwNZsIKh4Iw4DjhmTCgH0a2hxjLAJqheeNhmQehRN0KeIdrZUa33rjd2LmklWwz30O2uVOrkpDGyYISKePVzHW9FwtYrLA__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/d5a3/ab0b/d69053d2a2d046ae13160f10d7016118?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=mIe30GRo-HSMD93Uvajh-4ybfgwwUb2tz7BKW8n85MrvWYPpwhzaPsUYOryi9MUK3vrnXfu-SO~g4ArQnPvvDlTAHIGsFlyFDA7g6huEgDRQqScN8KdXOlk87pKOhYunq8DQKPzcnIqoT0PD7CV1B80CdVerip4eYgLxPBJhcZoAmz1dNMFAwEa5dfDF8GZpTE6cI5VdIGwc4ZJqqhIDml1okc-fS19z~-nvMFi7xyP12kyXgX5nTN0xVExXUvPuBosccVJGZC7RRA8u8XpXrHIo0cDiIROe51iBFEYrxFqjKaz2pJCPl-gVU7REaZVBVbpFt12y7IPyMnoNvjDO8g__'),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            9, 30, 66, 0.25),
                                                        blurRadius: 8,
                                                        spreadRadius: -2,
                                                        offset: Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              9, 30, 66, 0.08),
                                                          blurRadius: 0,
                                                          spreadRadius: 1),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                      'https://s3-alpha-sig.figma.com/img/ec86/6cb5/37c3e621fb133ea41e220439fd791633?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=jHTddlshVLY7XonVvo8mL6MlsDy3q1GdwSg6RbZBexwZA9ItmDhSRbBXjdUpJeoVWX0tE5Eh0rRT8FAWMLxNKfm3mqAxsuZB9KDGVW0p~TI~9LgB0At9MwDmRtQF-zMamYaSMacm3X4bfDXzZwzDCtBdDkiq4m0ygqdw1mR~XXG5fyZRGlfgdmucZdfYLP~U1kOTSLcmr~~8XHTyQ9IunfS8jiMFrrbNwkCmu0gppt3lzV9qV-KefF5RfPmSrxwxQWrYiUSyyTfujaEwRMStDQ2kO68nMbZXKDjlpY86UQSF6EiwmbOsruNiUm1ljIksJz67~MrILYITvBbwDK8I4g__'),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ])))));
  }
}

import 'package:consumo_de_api/data/repositories/implementations/dio_api_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../controllers/post_controller.dart';

// ignore: constant_identifier_names
const POST_ID_TO_LOAD = 1;

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late PostController _postCtrl;
  @override
  void initState() {
    _postCtrl = PostController(DioApiRepository(dio: Dio()));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _postCtrl.onLoadPost(POST_ID_TO_LOAD);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consumo de API com http e dio"),
      ),
      body: // carregando
          _postCtrl.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _postCtrl.getErrorLoadingPost == null
                  ?
                  // sucesso
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            _postCtrl.getLoadedPost?.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _postCtrl.getLoadedPost?.body ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          _postCtrl.getErrorLoadingPost!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: () => _postCtrl.onLoadPost(POST_ID_TO_LOAD),
                          child: const Text('Tentar novamente'),
                        )
                      ],
                    ),
    );
  }
}

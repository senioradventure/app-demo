import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/features/createCircle/bloc/create_circle_bloc.dart';
import 'package:senior_circle/features/createCircle/repositories/circle_repository.dart';

class CircleCreationScreen extends StatelessWidget {
  const CircleCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCircleBloc(repository: CircleRepository()),
      child: const CircleCreationView(),
    );
  }
}

class CircleCreationView extends StatefulWidget {
  const CircleCreationView({super.key});

  @override
  State<CircleCreationView> createState() => _CircleCreationViewState();
}

class _CircleCreationViewState extends State<CircleCreationView> {
  final TextEditingController txtController = TextEditingController();

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        context.read<CreateCircleBloc>().add(CreateCircleImagePicked(image));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCircleBloc, CreateCircleState>(
      listener: (context, state) {
        if (state.status == CreateCircleStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Circle created successfully!')),
          );
          Navigator.pop(context);
        } else if (state.status == CreateCircleStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    'Failed to create circle. Please try again.',
              ),
            ),
          );
        } else if (state.errorMessage != null &&
            state.status != CreateCircleStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: const Text(
              'Create Circle',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.black),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(height: 1, color: Colors.grey.shade300),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: ImagePickerCircle(
                                image: state.image,
                                onImagePicked: () => _pickImage(context),
                                size: 80,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${state.name.length}/40",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: txtController,
                              onChanged: (value) {
                                context.read<CreateCircleBloc>().add(
                                  CreateCircleNameChanged(value),
                                );
                              },
                              maxLength: 40,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Give you circle a name",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Add Friends (1)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Search for friends",
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          overscroll: false,
                        ),
                        child: Container(
                          color: Colors.white,
                          child: ListView(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              ...List.generate(
                                10,
                                (index) => Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    leading: Checkbox(
                                      value: false,
                                      onChanged: (value) {},
                                    ),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/member_avatar.jpg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Text(
                                            'Chai Talks',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.grey.shade300),
              InkWell(
                onTap: () {
                  if (state.status == CreateCircleStatus.loading) return;
                  context.read<CreateCircleBloc>().add(
                    const CreateCircleSubmitted(),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  color: const Color(0xFF4A90E2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.status == CreateCircleStatus.loading)
                        const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      else
                        const Icon(Icons.add, color: Colors.white),
                      if (state.status != CreateCircleStatus.loading)
                        const SizedBox(width: 8),
                      Text(
                        state.status == CreateCircleStatus.loading
                            ? "CREATING..."
                            : "CREATE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

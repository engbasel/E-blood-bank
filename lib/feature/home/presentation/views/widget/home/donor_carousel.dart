import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/feature/home/presentation/manger/health_bloc/health_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/health_bloc/health_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/health_bloc/health_state.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/health_loading_widget.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorCarousel extends StatelessWidget {
  const DonorCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<HealthBloc>();
        bloc.add(const FetchHealthNewsEvent());
        return bloc;
      },
      child: BlocBuilder<HealthBloc, HealthState>(
        builder: (context, state) {
          if (state is HealthLoading) {
            return const HealthLoadingWidget();
          } else if (state is HealthSuccess) {
            final articles = state.articles;
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return InfoCard(
                    content: article.content,
                    url: article.url,
                    description: article.description,
                    title: article.title,
                    image: article.image ??
                        'https://images.alphacoders.com/565/thumb-1920-565095.jpg',
                    publishedAt: article.publishedAt,
                    sourceName: article.sourceName,
                    sourceUrl: article.sourceUrl,
                  );
                },
              ),
            );
          } else if (state is HealthError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

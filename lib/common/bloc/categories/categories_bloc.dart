import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:monsey/common/model/category_model.dart';

import '../../graphql/config.dart';
import '../../graphql/queries.dart';
import 'bloc_categories.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesLoading()) {
    on<InitialCategories>(_onInitialCategories);
  }

  User firebaseUser = FirebaseAuth.instance.currentUser!;

  Future<void> _onInitialCategories(
      InitialCategories event, Emitter<CategoriesState> emit) async {
    // emit(CategoriesLoading());
    try {
      final List<Map<String, dynamic>> categories = [];
      final List<CategoryModel> resultCategories = await getCategories();
      for (CategoryModel category in resultCategories) {
        if (category.parrentId == null) {
          categories.add(<String, dynamic>{
            'parrent': category,
            'child': <CategoryModel>[]
          });
        }
      }
      for (Map<String, dynamic> category in categories) {
        for (CategoryModel categoryDetail in resultCategories) {
          if (categoryDetail.parrentId == category['parrent'].id) {
            category['child'].add(categoryDetail);
          }
        }
      }
      emit(CategoriesLoaded(categories: categories));
    } catch (_) {
      emit(CategoriesError());
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final List<CategoryModel> categories = [];
    final String token = await firebaseUser.getIdToken();
    await Config.initializeClient(token)
        .value
        .query(QueryOptions(document: gql(Queries.getCategories)))
        .then((value) {
      if (value.data!.isNotEmpty && value.data!['Category'].length > 0) {
        for (Map<String, dynamic> type in value.data!['Category']) {
          categories.add(CategoryModel.fromJson(type));
        }
      }
    });
    return categories;
  }
}

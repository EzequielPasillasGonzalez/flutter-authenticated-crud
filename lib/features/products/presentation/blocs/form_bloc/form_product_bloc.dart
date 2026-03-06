import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'form_product_event.dart';
part 'form_product_state.dart';

class FormProductBloc extends Bloc<FormProductEvent, FormProductState> {
  FormProductBloc() : super(FormProductState()) {
    on<FormProductEvent>((event, emit) {
      //TODO: id
      //TODO: title
      //TODO: slug
      //TODO: price
      //TODO: size
      //TODO: gender
      //TODO: intStock
      //TODO: descrpition
      //TODO: tags
      //TODO: images
    });
  }
}

enum Status { loading, success, error }

class Resource<T> {
  final Status status;
  final T? data;
  final String? message;

  Resource.loading() : status = Status.loading, data = null, message = null;
  Resource.success(this.data) : status = Status.success, message = null;
  Resource.error(this.message) : status = Status.error, data = null;
}

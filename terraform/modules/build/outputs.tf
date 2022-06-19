output "codecommit_ssh" {
	value = aws_codecommit_repository.kittens.clone_url_ssh
}
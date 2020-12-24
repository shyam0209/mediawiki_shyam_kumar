data "template_file" "user_data" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    db_root_pwd  = var.db_root_pwd
    wiki_db_user = var.wiki_db_user
    wiki_db_pwd  = var.wiki_db_pwd
    wiki_db      = var.wiki_db
    wiki_user    = var.wiki_user
    wiki_pwd     = var.wiki_pwd
    wiki_name    = var.wiki_name
  }
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = var.public_key
}

resource "aws_instance" "mediawiki" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  key_name        = aws_key_pair.key.key_name
  user_data       = data.template_file.user_data.rendered
  security_groups = [aws_security_group.media_web.id]
  subnet_id       = aws_subnet.subnet_public.id
}
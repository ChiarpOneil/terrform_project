#DATABASE
resource "aws_db_instance" "main" {
    for_each             = {for db in var.db: "${db.db_name}"=> {
        db_subnet_group_name = db.db_subnet_group_name
        vpc_security_group_ids = [for vpc_sec in db.vpc_security_group_ids: var.security_group_ids[vpc_sec] ]
        engine                  = db.engine
        engine_version          = db.engine_version
        instance_class          = db.instance_class
        username                = db.username
        password                = db.password
        parameter_group_name    = db.parameter_group_name
    }}
    identifier = each.key
    backup_retention_period = 1
    backup_window           = "07:00-09:00"

    depends_on           = [aws_db_subnet_group.main]
    allocated_storage       = 5
    db_name                 = each.key
    engine                  = each.value.engine
    engine_version          = each.value.engine_version
    instance_class          = each.value.instance_class
    username                = each.value.username
    password                = each.value.password
    parameter_group_name    = each.value.parameter_group_name

    skip_final_snapshot     = true
    vpc_security_group_ids = each.value.vpc_security_group_ids
    db_subnet_group_name = aws_db_subnet_group.main[each.value.db_subnet_group_name].name
    tags = {
      Name = "Giovanni-${each.key}"
    }
}

#SUBNET GROUP
resource "aws_db_subnet_group" "main" {
  for_each   = {for sub_g in var.security_group: "${sub_g.name}" => {
    subnet = [for subnet in sub_g.subnet_ids : var.subnet_ids[subnet]]
  }}
  name       = each.key
  subnet_ids = each.value.subnet
  tags = {
    Name = "GIOVANNI-${each.key}"
  }
}

#SNAPSHOT 
resource "aws_db_snapshot" "main" {
  count = length(var.snapshot)
  db_instance_identifier = var.snapshot[count.index].id
  db_snapshot_identifier = var.snapshot[count.index].name
  depends_on = [ aws_db_instance.main ]
}

resource "aws_db_instance" "snap" {
  for_each             = {for db in var.db_snap: "${db.snapshot}${index(var.db_snap,db)}"=> {
        vpc_security_group_ids = [for vpc_sec in db.vpc_security_group_ids: var.security_group_ids[vpc_sec] ]
        snapshot = db.snapshot
        instance_class = db.instance_class
    }}
  identifier = each.key
  snapshot_identifier = each.value.snapshot
  instance_class = each.value.instance_class
  depends_on = [ aws_db_snapshot.main ]
}


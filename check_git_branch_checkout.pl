#!/usr/bin/perl -T
# nagios: -epn
#
#  Author: Hari Sekhon
#  Date: 2012-07-26 12:09:53 +0100 (Thu, 26 Jul 2012)
#
#  http://github.com/harisekhon
#
#  License: see accompanying LICENSE file
#

$DESCRIPTION = "Nagios Plugin to check a Git working copy is in the right branch.

Primarily written for puppetmasters to make sure prod and staging
environment dirs had the right branches checked out in them";

$VERSION = "0.2";

use strict;
use warnings;
BEGIN {
    use File::Basename;
    use lib dirname(__FILE__) . "/lib";
}
use HariSekhonUtils;

my $directory;
my $branch;
my $branch_checkout;
my $git_default = "git";
my $git = $git_default;
%options = (
    "d|directory=s" => [ \$directory, "Directory path to git working copy" ],
    "b|branch=s"    => [ \$branch,    "Branch to expect working copy checkout to be" ],
    "git-binary=s"  => [ \$git,       "Path to git binary. Defaults to '$git_default'" ],
);
@usage_order = qw/directory branch/;

get_options();

$directory = validate_directory($directory);
$branch or usage "branch name not specified";
$branch    =~ /^([\w-]+)$/ or usage "Invalid branch name given, must be alpha-numeric";
$branch    = $1;
$git       = validate_program_path($git, "git");

vlog2 "directory: $directory
branch:    $branch
";
set_timeout();

chdir($directory) or quit "CRITICAL", "Failed to chdir to directory '$directory'";
my @output = cmd("$git branch --color=never", 1);
foreach(@output){
    if(/^\*\s+(.+)\s*$/){
        $branch_checkout = $1;
        last;
    }
}
defined($branch_checkout) or quit "CRITICAL", "Failed to determine current branch checkout for directory '$directory'";

if($branch_checkout eq $branch){
    quit "OK", "branch '$branch_checkout' currently checked out in directory '$directory'";
} else {
    quit "CRITICAL", "branch '$branch_checkout' checked out, expecting '$branch' in directory '$directory'";
}

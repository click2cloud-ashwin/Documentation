# Getting started

This document describes how to setup your development environment.

1. Install the prerequisites
   For a fully manual install, execute the following lines to first clone the `nvm` repository into `$HOME/.nvm`, and then load `nvm`:

```bash
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
```

Now add these lines to your `~/.bashrc`, `~/.profile`, or `~/.zshrc` file to have it automatically sourced upon login:
(you may have to add to more than one of the above files)

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```
Note: After adding above lines to profile, run the `source` command with respective bash profile file.

Install the node version 12
```bash
nvm install 12
```

Install node dependencies
```bash
sudo apt install nodejs -y
sudo apt install npm -y
sudo apt install build-essential ruby-full node-typescript -y
npm install --global typescript
npm install --global gulp-cli
npm install --global gulp
```

2. Clone the repository.

```bash
git clone https://github.com/Click2Cloud-Centaurus/dashboard.git $HOME/dashboard -b dev-scale-out
cd $HOME/dashboard
```

3. Install the dashboard project dependencies:
```bash
npm ci
```

If you are running commands with root privileges set `--unsafe-perm flag`:

```bash
npm ci --unsafe-perm
```

4. Make sure your arktos cluster is running, run the command from arktos directory.
```bash
./cluster/kubectl.sh get nodes -A
```
output of above command
```text
NAME               STATUS   ROLES    AGE   VERSION
centaurus-master   Ready    <none>   30m   v0.9.0
```
5. Create a link for kubeconfig file using following command.

Run following command, if cluster is created using **arktos-up** script
```bash
ln -snf /var/run/kubernetes/admin.kubeconfig $HOME/.kube/config
```
Run following command, if cluster is created using **kube-up** script
```bash
ln -snf $HOME/go/src/k8s.io/arktos/cluster/kubeconfig-proxy $HOME/.kube/config
```

For scale-out, 
convert the kubeconfig files depending on the architecture `e.g. 2RP, 2TP`, to **Base64Encoded** format one by one and export them as 

```bash
export RP1_CONFIG=<encoded_kubeconfig>
export TP1_CONFIG=<encoded_kubeconfig>
export RP2_CONFIG=<encoded_kubeconfig>
export TP2_CONFIG=<encoded_kubeconfig>
```

6.Deploy postgres container
```bash
docker run --name postgresql-container -p <db_port>:5432 -e POSTGRES_PASSWORD=<db_password> -d <postgres_db>
```

```bash
export POSTGRES_DB=<postgres_db>
export DB_HOST=<host_IP_address>
export DB_PORT=<db_port>
export POSTGRES_USER=<postgres_username>
export POSTGRES_PASSWORD=<password>
```

7. Update the .npmrc and angular.json file in the dashboard directory for bind address and port.

```bash
cd $HOME/dashboard
sudo sed -i '/bind_address/s/^/#/g' $HOME/dashboard/.npmrc
sudo sed -i 's/8080/9443/g' $HOME/dashboard/angular.json
sudo sed -i '0,/RANDFILE/{s/RANDFILE/\#&/}' /etc/ssl/openssl.cnf
echo 'kubernetes-dashboard:bind_address = 0.0.0.0 '>> $HOME/dashboard/.npmrc 
```

8. To run dashboard:

```bash
npm run start:https --kubernetes-dashboard:kubeconfig=$HOME/.kube/config
```
Leave the terminal running.

## To access the dashboard

Dashboard will be accessible on `https://<machine_ip>:9443`

`<machine_ip>`, where `npm run` command is running.

Default credentials are as follows:

username: `centaurus`

password: `Centaurus@123`



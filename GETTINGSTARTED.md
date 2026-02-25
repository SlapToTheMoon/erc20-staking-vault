## Getting Started

### 1. Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup 
```

### 2. Clone the repo 

```bash
git clone <YOUR_REPO_URL>.git
cd erc20-staking-vault
```

### 3. Install dependencies

```bash
forge build   # will fetch libs if needed
```

If openzeppelin-contracts is missing:

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge build
```

### 4. Run tests & coverage

```bash
forge test
forge coverage
```

## Deployment with testnets

```bash
**Sepolia example:**

export SEPOLIA_RPC_URL="https://sepolia.infura.io/v3/YOUR_KEY"

forge script script/Deploy.s.sol:Deploy \
  --rpc-url sepolia \
  --broadcast \
  --account deployer \
  -vvvv

**Fuji example:**
  export FUJI_RPC_URL="https://api.avax-test.network/ext/bc/C/rpc"

forge script script/Deploy.s.sol:Deploy \
  --rpc-url fuji \
  --broadcast \
  --account deployer \
  -vvvv
  ```
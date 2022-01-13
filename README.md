# ICO Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat test
```

For designing a vesting token approach, we could change redeem function and makes it controlling which tokens are being released and just transfer only after a amount of time last token was released, not allowing consecutives requests.

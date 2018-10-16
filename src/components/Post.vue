<template>
  <div>
    <div v-if="showMenu">
      <div v-on:click="changePost('register')">
        <md-card class="md-layout-item md-size-20 md-large-size-30 md-medium-size-40 md-small-size-60 md-xsmall-size-100 options" md-with-hover>
          <md-ripple>
            <md-card-header>
              <div class="md-title">Hero Register</div>
              <div class="md-subhead">Register a Super Hero to Blockchain</div>
            </md-card-header>
            <md-card-content>
            </md-card-content>
          </md-ripple>
        </md-card>
      </div>

      <div v-on:click="changePost('review')">
        <md-card class="md-layout-item md-size-20 md-large-size-30 md-medium-size-40 md-small-size-60 md-xsmall-size-100 options" md-with-hover>
          <md-ripple>
            <md-card-header>
              <div class="md-title">Hero Review</div>
              <div class="md-subhead">Review an hero with comments</div>
            </md-card-header>
            <md-card-content>
            </md-card-content>
          </md-ripple>
        </md-card>
      </div>

      <div v-on:click="changePost('procure')">
        <md-card class="md-layout-item md-size-20 md-large-size-30 md-medium-size-40 md-small-size-60 md-xsmall-size-100 options" md-with-hover>
          <md-ripple>
            <md-card-header>
              <div class="md-title">Hero Procure</div>
              <div class="md-subhead">Procure an hero from another manager</div>
            </md-card-header>
            <md-card-content>
            </md-card-content>
          </md-ripple>
        </md-card>
      </div>
    </div>

    <div v-if="showRegister">
      <md-dialog class="wallet" :md-click-outside-to-close=false :md-active.sync="isSigning">
        <md-toolbar class="md-accent md-dense">
          <h3 class="md-title">Signing this Transaction</h3>
        </md-toolbar>

        <div class="wallet-content">
          <div class="md-caption">Please make sure you have enough balance,</div>
          <div class="md-caption">otherwise the transaction will be failed!!!</div>
          <br>
          <div class="md-layout md-alignment-center-left">
            <div class="md-layout-item md-size-60">
              <md-field>
                <label>Balance in Rinkeby</label>
                <md-input v-model="accountBalance" readonly></md-input>
              </md-field>
            </div>

            <md-button class="md-icon-button" @click="getCurrentWallet">
              <md-icon>
                refresh
                <md-tooltip md-direction="top">Refresh</md-tooltip>
              </md-icon>
            </md-button>

            <md-button class="md-icon-button" href="https://faucet.rinkeby.io/" target="_blank">
              <md-icon>
                input
                <md-tooltip md-direction="top">Deposit</md-tooltip>
              </md-icon>
            </md-button>
          </div>
          <br>
          <br>
          <br>
        </div>
        <md-dialog-actions class="md-layout">
            <md-button class="md-accent md-raised" @click="unlockWallet">Sign</md-button>
        </md-dialog-actions>
      </md-dialog>

      <div class="post-form">
        <form novalidate class="md-layout" @submit.prevent="validateRecord">
          <md-card class="md-layout-item md-size-20 md-large-size-30 md-medium-size-40 md-small-size-60 md-xsmall-size-100">
            <md-card-header>
              <div class="title">Register an Hero</div>
            </md-card-header>

            <md-card-content class="post-card">
              <strong style="color:#64dd17;">About the Superhero</strong>
              <div class="md-layout md-gutter">
                <div class="md-layout-item md-size-80">
                  <md-field :class="getValidationClass('SuperHero_CodeName')">
                    <label for="SuperHero_CodeName">Code Name</label>
                    <md-input name="SuperHero_CodeName" id="SuperHero_CodeName" v-model="form.SuperHero_CodeName" :disabled="sending" />
                    <span class="md-error" v-if="!$v.form.SuperHero_CodeName.required">The Hero Code Name is required</span>
                    <span class="md-error" v-else-if="!$v.form.SuperHero_CodeName.minlength">The code name is too short</span>
                  </md-field>
                </div>
              </div>

              <div class="md-layout md-gutter">
                <div class="md-layout-item md-size-80">
                  <md-field :class="getValidationClass('SuperHero_TagID')">
                    <label for="SuperHero_TagID">Tag ID</label>
                    <md-input name="SuperHero_TagID" id="SuperHero_TagID" v-model="form.SuperHero_TagID" :disabled="sending" />
                    <span class="md-error" v-if="!$v.form.SuperHero_TagID.required">The Tag ID is required</span>
                    <span class="md-error" v-else-if="!$v.form.SuperHero_TagID.minlength">The Tag ID is too short</span>
                  </md-field>
                </div>
              </div>

              <div class="md-layout md-gutter">
                <div class="md-layout-item md-size-80">
                <md-field :class="getValidationClass('img')">
                  <label for="img">Hero Portrait</label>
                  <md-file name="img" id="img" v-model="form.img" accept="image/*" :disabled="sending" />
                  <span class="md-error" v-if="!$v.form.img.required">An Hero Image is required</span>
                </md-field>
                </div>
              </div>
            </md-card-content>

            <md-progress-bar md-mode="indeterminate" v-if="sending"/>

            <md-card-actions>
              <md-button type="submit" class="md-accent md-raised" :disabled="sending">Submit</md-button>
            </md-card-actions>
          </md-card>

          <md-snackbar :md-active.sync="recordSaved">The record was Posted, sign with your wallet now!!!</md-snackbar>
          <md-snackbar :md-active.sync="recordSigned">The record was Signed, Congratulations!!!</md-snackbar>
          <md-snackbar :md-active.sync="noWalletLogged">Please click the wallet button on the top right corner to login!!!</md-snackbar>
        </form>
      </div>
    </div>

    <div v-if="showReview">
      <md-dialog class="wallet" :md-click-outside-to-close=false :md-active.sync="isSigning">
        <md-toolbar class="md-accent md-dense">
          <h3 class="md-title">Signing this Transaction</h3>
        </md-toolbar>

        <div class="wallet-content">
          <div class="md-caption">Please make sure you have enough balance,</div>
          <div class="md-caption">otherwise the transaction will be failed!!!</div>
          <br>
          <div class="md-layout md-alignment-center-left">
            <div class="md-layout-item md-size-60">
              <md-field>
                <label>Balance in Rinkeby</label>
                <md-input v-model="accountBalance" readonly></md-input>
              </md-field>
            </div>

            <md-button class="md-icon-button" @click="getCurrentWallet">
              <md-icon>
                refresh
                <md-tooltip md-direction="top">Refresh</md-tooltip>
              </md-icon>
            </md-button>

            <md-button class="md-icon-button" href="https://faucet.rinkeby.io/" target="_blank">
              <md-icon>
                input
                <md-tooltip md-direction="top">Deposit</md-tooltip>
              </md-icon>
            </md-button>
          </div>
          <br>
          <br>
          <br>
        </div>
        <md-dialog-actions class="md-layout">
            <md-button class="md-accent md-raised" @click="unlockWallet">Sign</md-button>
        </md-dialog-actions>
      </md-dialog>

      <div class="post-form">
        <md-card class="md-layout-item md-size-20 md-large-size-30 md-medium-size-40 md-small-size-60 md-xsmall-size-100">
          <md-card-header>
            <div class="title">Review an Hero</div>
          </md-card-header>

          <md-card-content class="post-card">
            <strong style="color:#64dd17;">About the Superhero</strong>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="selectedHero">Tag ID</label>

                  <md-select v-model="selectedHero" name="selectedHero" id="selectedHero" placeholder="Select an Hero" :disabled="sending">
                    <md-option v-for="hero in registeredHeroes" v-bind:key="hero.payload.inputs.SuperHero_TagID" v-bind:value="hero.payload.inputs.SuperHero_TagID">
                      {{ hero.payload.inputs.SuperHero_TagID }}
                    </md-option>

                  </md-select>
                </md-field>
              </div>
            </div>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="Hero_Manager">Hero Manager</label>
                  <md-input name="Hero_Manager" id="Hero_Manager" v-model="Hero_Manager" :disabled="sending" />
                </md-field>
              </div>
            </div>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="Job_To_Do">Job To Do</label>
                  <md-input name="Job_To_Do" id="Job_To_Do" v-model="Job_To_Do" :disabled="sending" />
                </md-field>
              </div>
            </div>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="Review_Comments">Review Comments</label>
                  <md-textarea name="Review_Comments" id="Review_Comments" v-model="Review_Comments" :disabled="sending" />
                </md-field>
              </div>
            </div>

          </md-card-content>

          <md-progress-bar md-mode="indeterminate" v-if="sending"/>

          <md-card-actions>
            <md-button type="submit" class="md-accent md-raised" :disabled="!(Hero_Manager && selectedHero && Job_To_Do && Review_Comments)"  v-on:click="saveReview()">Submit</md-button>
          </md-card-actions>
        </md-card>

        <md-snackbar :md-active.sync="recordSaved">The record was Posted, sign with your wallet now!!!</md-snackbar>
        <md-snackbar :md-active.sync="recordSigned">The record was Signed, Congratulations!!!</md-snackbar>
        <md-snackbar :md-active.sync="noWalletLogged">Please click the wallet button on the top right corner to login!!!</md-snackbar>
      </div>
    </div>

    <div v-if="showProcure">
      <md-dialog class="wallet" :md-click-outside-to-close=false :md-active.sync="isSigning">
        <md-toolbar class="md-accent md-dense">
          <h3 class="md-title">Signing this Transaction</h3>
        </md-toolbar>

        <div class="wallet-content">
          <div class="md-caption">Please make sure you have enough balance,</div>
          <div class="md-caption">otherwise the transaction will be failed!!!</div>
          <br>
          <div class="md-layout md-alignment-center-left">
            <div class="md-layout-item md-size-60">
              <md-field>
                <label>Balance in Rinkeby</label>
                <md-input v-model="accountBalance" readonly></md-input>
              </md-field>
            </div>

            <md-button class="md-icon-button" @click="getCurrentWallet">
              <md-icon>
                refresh
                <md-tooltip md-direction="top">Refresh</md-tooltip>
              </md-icon>
            </md-button>

            <md-button class="md-icon-button" href="https://faucet.rinkeby.io/" target="_blank">
              <md-icon>
                input
                <md-tooltip md-direction="top">Deposit</md-tooltip>
              </md-icon>
            </md-button>
          </div>
          <br>
          <br>
          <br>
        </div>
        <md-dialog-actions class="md-layout">
            <md-button class="md-accent md-raised" @click="unlockWallet">Sign</md-button>
        </md-dialog-actions>
      </md-dialog>

      <div class="post-form">
        <md-card class="md-layout-item md-size-20 md-large-size-30 md-medium-size-40 md-small-size-60 md-xsmall-size-100">
          <md-card-header>
            <div class="title">Procure an Hero</div>
          </md-card-header>

          <md-card-content class="post-card">
            <strong style="color:#64dd17;">About the Superhero</strong>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="selectedHero">Tag ID</label>

                  <md-select v-model="selectedHero" name="selectedHero" id="selectedHero" placeholder="Select an Hero" :disabled="sending">
                    <md-option v-for="hero in reviewedHeroes" v-bind:key="hero.payload.inputs.SuperHero_TagID" v-bind:value="hero.payload.inputs.SuperHero_TagID">
                      {{ hero.payload.inputs.SuperHero_TagID }}
                    </md-option>

                  </md-select>
                </md-field>
              </div>
            </div>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="Hero_Manager">New Hero Manager</label>
                  <md-input name="Hero_Manager" id="Hero_Manager" v-model="Hero_Manager" :disabled="sending" />
                </md-field>
              </div>
            </div>

            <div class="md-layout md-gutter">
              <div class="md-layout-item md-size-80">
                <md-field>
                  <label for="Job_To_Do">New Job To Do</label>
                  <md-input name="Job_To_Do" id="Job_To_Do" v-model="Job_To_Do" :disabled="sending" />
                </md-field>
              </div>
            </div>

          </md-card-content>

          <md-progress-bar md-mode="indeterminate" v-if="sending"/>

          <md-card-actions>
            <md-button type="submit" class="md-accent md-raised" :disabled="!(Hero_Manager && selectedHero && Job_To_Do)" v-on:click="saveProcure()">Submit</md-button>
          </md-card-actions>
        </md-card>

        <md-snackbar :md-active.sync="recordSaved">The record was Posted, sign with your wallet now!!!</md-snackbar>
        <md-snackbar :md-active.sync="recordSigned">The record was Signed, Congratulations!!!</md-snackbar>
        <md-snackbar :md-active.sync="noWalletLogged">Please click the wallet button on the top right corner to login!!!</md-snackbar>
      </div>
    </div>

  </div>
</template>

<script>
import { validationMixin } from 'vuelidate'
import { localstorage } from './mixins/localstorage'
import ethers from 'ethers'
import simbaApi from './gateways/simba-api'
import {
  required,
  minLength
} from 'vuelidate/lib/validators'

export default {
  name: 'post',
  mixins: [validationMixin, localstorage],
  data: () => ({
    form: {
      SuperHero_CodeName: null,
      SuperHero_TagID: null,
      img: null
    },

    selectedHero: null,
    Hero_Manager: null,
    Job_To_Do: null,
    Review_Comments: null,

    sending: false,
    recordSaved: false,
    recordSigned: false,
    noWalletLogged: false,
    accountBalance: null,
    txnId: null,
    unsignedTxn: null,
    isSigning: false,
    showRegister: false,
    showReview: false,
    showProcure: false,
    showMenu: true,

    registeredHeroes: null,
    reviewedHeroes: null
  }),
  validations: {
    form: {
      SuperHero_CodeName: {
        required,
        minLength: minLength(2)
      },
      SuperHero_TagID: {
        required,
        minLength: minLength(3)
      },
      img: {
        required
      }
    }
  },
  methods: {
    getCurrentWallet () {
      let address = this.getAddress()
      this.getBalance(address)
    },
    getBalance (address) {
      let self = this
      let providers = ethers.providers
      let provider = providers.getDefaultProvider('rinkeby')
      provider.getBalance(address).then(function (balance) {
        let etherString = ethers.utils.formatEther(balance)
        self.accountBalance = etherString + ' ETH'
        self.isSigning = true
      })
    },
    unlockWallet () {
      try {
        let mnemonic = this.getWallet()
        this.sendTxn(mnemonic)
      } catch (e) {
        console.log(e)
      }
    },
    sendTxn (mnemonic) {
      let wallet = ethers.Wallet.fromMnemonic(mnemonic)
      let signedTxn = wallet.sign(this.unsignedTxn)
      let self = this
      let txnId = this.txnId
      let payload = {
        'payload': signedTxn
      }
      try {
        simbaApi.signTxn('transaction/' + txnId + '/', payload).then(function () {
          self.recordSigned = true
          self.isSigning = false
        })
      } catch (e) {
        console.log(e)
      }
    },
    changePost (post) {
      switch (post) {
        case 'register':
          this.showRegister = true
          this.showReview = false
          this.showProcure = false
          this.showMenu = false
          break
        case 'review':
          this.showRegister = false
          this.showReview = true
          this.showProcure = false
          this.showMenu = false
          this.getRegisteredHeros()
          break
        case 'procure':
          this.showRegister = false
          this.showReview = false
          this.showProcure = true
          this.showMenu = false
          this.getReviewedHeros()
          break
        case 'menu':
          this.showRegister = false
          this.showReview = false
          this.showProcure = false
          this.showMenu = true
          break
      }
    },
    getRegisteredHeros () {
      let self = this
      try {
        simbaApi.getData('Register_Hero/?no_page=1/')
          .then(function (response) {
            self.registeredHeroes = response.data.results
          })
      } catch (e) {
        this.errors.push(e)
      }
    },
    getReviewedHeros () {
      let self = this
      try {
        simbaApi.getData('Review_Hero/?no_page=1/')
          .then(function (response) {
            self.reviewedHeroes = response.data.results
          })
      } catch (e) {
        this.errors.push(e)
      }
    },
    getValidationClass (fieldName) {
      const field = this.$v.form[fieldName]
      if (field) {
        return {
          'md-invalid': field.$invalid && field.$dirty
        }
      }
    },
    clearForm () {
      this.$v.$reset()
      this.form.SuperHero_CodeName = null
      this.form.SuperHero_TagID = null
      this.form.img = null
    },
    clearForm2 () {
      this.$v.$reset()
      this.selectedHero = null
      this.Hero_Manager = null
      this.Job_To_Do = null
      this.Review_Comments = null
      this.Date_Procured = null
    },
    saveRecord (e) {
      if (!this.getWallet()) {
        this.noWalletLogged = true
        return
      }
      this.sending = true
      let bodyFormData = new FormData()
      bodyFormData.append('from', this.getAddress())
      bodyFormData.append('SuperHero_TagID', this.form.SuperHero_TagID)
      bodyFormData.append('SuperHero_CodeName', this.form.SuperHero_CodeName)
      bodyFormData.append('file[0]', document.getElementById('img').files[0])

      bodyFormData.append('SuperHero', 'anything')
      bodyFormData.append('assetId', 'anything')

      let self = this
      try {
        simbaApi.postData('Register_Hero/', bodyFormData).then(function (res) {
          self.txnId = res.data.id
          self.unsignedTxn = res.data.payload.raw
          self.getCurrentWallet()
          self.recordSaved = true
          self.sending = false
          self.clearForm()
        })
      } catch (e) {
        console.log(e)
      }
    },
    saveReview (e) {
      if (!this.getWallet()) {
        this.noWalletLogged = true
        return
      }
      this.sending = true
      let bodyFormData = new FormData()
      bodyFormData.append('from', this.getAddress())
      bodyFormData.append('SuperHero_TagID', this.selectedHero)
      bodyFormData.append('Hero_Manager', this.Hero_Manager)
      bodyFormData.append('Job_To_Do', this.Job_To_Do)
      bodyFormData.append('Date_Reviewed', (new Date()).getTime())
      bodyFormData.append('Review_Comments', this.Review_Comments)

      bodyFormData.append('SuperHero', 'anything')
      bodyFormData.append('assetId', 'anything')

      let self = this
      try {
        simbaApi.postData('Review_Hero/', bodyFormData).then(function (res) {
          self.txnId = res.data.id
          self.unsignedTxn = res.data.payload.raw
          self.getCurrentWallet()
          self.recordSaved = true
          self.sending = false
          self.clearForm2()
        })
      } catch (e) {
        console.log(e)
      }
    },
    saveProcure () {
      if (!this.getWallet()) {
        this.noWalletLogged = true
        return
      }
      this.sending = true
      let bodyFormData = new FormData()
      bodyFormData.append('from', this.getAddress())
      bodyFormData.append('SuperHero_TagID', this.selectedHero)
      bodyFormData.append('Hero_Manager', this.Hero_Manager)
      bodyFormData.append('Job_To_Do', this.Job_To_Do)
      bodyFormData.append('Date_Procured', (new Date()).getTime())

      bodyFormData.append('SuperHero', 'anything')
      bodyFormData.append('assetId', 'anything')

      let self = this
      try {
        simbaApi.postData('Procure_Hero_Service/', bodyFormData).then(function (res) {
          self.txnId = res.data.id
          self.unsignedTxn = res.data.payload.raw
          self.getCurrentWallet()
          self.recordSaved = true
          self.sending = false
          self.clearForm2()
        })
      } catch (e) {
        console.log(e)
      }
    },
    validateRecord () {
      this.$v.$touch()
      if (!this.$v.$invalid) {
        this.saveRecord()
      }
    }
  }
}
</script>

<style scoped>
  .my-card {
    margin-top: 40px;
    width: 300px;
    display: inline-block;
    vertical-align: top;
    margin-bottom: 20px;
  }
  .md-progress-bar {
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
  }
  .post-form {
    margin-top: 40px;
    height: 550px;
  }
  .title {
    font-size: 20px;
    margin-left: 10px;
    margin-top: 7px;
  }
  .post-card {
    margin: 10px;
  }
  .options {
    margin-top: 40px;
  }
  .wallet {
    min-width: 320px;
  }
  .wallet-content {
    margin: 20px;
  }
</style>

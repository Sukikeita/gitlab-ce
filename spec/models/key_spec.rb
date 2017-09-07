require 'spec_helper'

describe Key, :mailer do
  include Gitlab::CurrentSettings

  describe 'modules' do
    subject { described_class }
    it { is_expected.to include_module(Gitlab::CurrentSettings) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "Validation" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }

    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_length_of(:key).is_at_most(5000) }
    it { is_expected.to allow_value(attributes_for(:rsa_key_2048)[:key]).for(:key) }
    it { is_expected.to allow_value(attributes_for(:dsa_key_2048)[:key]).for(:key) }
    it { is_expected.to allow_value(attributes_for(:ecdsa_key_256)[:key]).for(:key) }
    it { is_expected.to allow_value(attributes_for(:ed25519_key_256)[:key]).for(:key) }
    it { is_expected.not_to allow_value('foo-bar').for(:key) }
  end

  describe "Methods" do
    let(:user) { build_stubbed(:user) }
    it { is_expected.to respond_to :projects }
    it { is_expected.to respond_to :publishable_key }

    describe "#publishable_keys" do
      it 'replaces SSH key comment with simple identifier of username + hostname' do
        expect(build(:key, user: user).publishable_key).to include("#{user.name} (#{Gitlab.config.gitlab.host})")
      end
    end

    describe "#update_last_used_at" do
      let(:key) { build_stubbed(:key) }

      context 'when key was not updated during the last day' do
        before do
          allow_any_instance_of(Gitlab::ExclusiveLease).to receive(:try_obtain)
            .and_return('000000')
        end

        it 'enqueues a UseKeyWorker job' do
          expect(UseKeyWorker).to receive(:perform_async).with(key.id)
          key.update_last_used_at
        end
      end

      context 'when key was updated during the last day' do
        before do
          allow_any_instance_of(Gitlab::ExclusiveLease).to receive(:try_obtain)
            .and_return(false)
        end

        it 'does not enqueue a UseKeyWorker job' do
          expect(UseKeyWorker).not_to receive(:perform_async)
          key.update_last_used_at
        end
      end
    end
  end

  context "validation of uniqueness (based on fingerprint uniqueness)" do
    let(:user) { build_stubbed(:user) }

    it "accepts the key once" do
      expect(build(:key, user: user)).to be_valid
    end

    it "does not accept the exact same key twice" do
      first_key = build_stubbed(:key, user: user)

      expect(build(:key, user: user, key: first_key.key)).not_to be_valid
    end

    it "does not accept a duplicate key with a different comment" do
      first_key = build_stubbed(:key, user: user)
      duplicate = build(:key, user: user, key: first_key.key)
      duplicate.key << ' extra comment'

      expect(duplicate).not_to be_valid
    end
  end

  context "validate it is a fingerprintable key" do
    it "accepts the fingerprintable key" do
      expect(build(:key)).to be_valid
    end

    it 'accepts a key with newline charecters after stripping them' do
      key = build(:key)
      key.key = key.key.insert(100, "\n")
      key.key = key.key.insert(40, "\r\n")
      expect(key).to be_valid
    end

    it 'rejects the unfingerprintable key (not a key)' do
      expect(build(:key, key: 'ssh-rsa an-invalid-key==')).not_to be_valid
    end
  end

  context 'validate it meets key restrictions' do
    where(:factory, :minimum, :result) do
      forbidden = ApplicationSetting::FORBIDDEN_KEY_VALUE

      [
        [:rsa_key_2048,    0, true],
        [:dsa_key_2048,    0, true],
        [:ecdsa_key_256,   0, true],
        [:ed25519_key_256, 0, true],

        [:rsa_key_2048, 1024, true],
        [:rsa_key_2048, 2048, true],
        [:rsa_key_2048, 4096, false],

        [:dsa_key_2048, 1024, true],
        [:dsa_key_2048, 2048, true],
        [:dsa_key_2048, 4096, false],

        [:ecdsa_key_256, 256, true],
        [:ecdsa_key_256, 384, false],

        [:ed25519_key_256, 256, true],
        [:ed25519_key_256, 384, false],

        [:rsa_key_2048,    forbidden, false],
        [:dsa_key_2048,    forbidden, false],
        [:ecdsa_key_256,   forbidden, false],
        [:ed25519_key_256, forbidden, false]
      ]
    end

    with_them do
      subject(:key) { build(factory) }

      before do
        stub_application_setting("#{key.public_key.type}_key_restriction" => minimum)
      end

      it { expect(key.valid?).to eq(result) }
    end
  end

  context 'callbacks' do
    it 'adds new key to authorized_file' do
      key = build(:personal_key, id: 7)
      expect(GitlabShellWorker).to receive(:perform_async).with(:add_key, key.shell_id, key.key)
      key.save!
    end

    it 'removes key from authorized_file' do
      key = build_stubbed(:personal_key)
      expect(GitlabShellWorker).to receive(:perform_async).with(:remove_key, key.shell_id, key.key)
      key.destroy
    end
  end

  describe '#key=' do
    let(:valid_key) do
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAiPWx6WM4lhHNedGfBpPJNPpZ7yKu+dnn1SJejgt4596k6YjzGGphH2TUxwKzxcKDKKezwkpfnxPkSMkuEspGRt/aZZ9wa++Oi7Qkr8prgHc4soW6NUlfDzpvZK2H5E7eQaSeP3SAwGmQKUFHCddNaP0L+hM7zhFNzjFvpaMgJw0= dummy@gitlab.com"
    end

    it 'strips white spaces' do
      expect(described_class.new(key: " #{valid_key} ").key).to eq(valid_key)
    end
  end

  describe 'notification' do
    let(:user) { build_stubbed(:user) }

    it 'sends a notification' do
      perform_enqueued_jobs do
        build_stubbed(:key, user: user)
      end

      should_email(user)
    end
  end
end

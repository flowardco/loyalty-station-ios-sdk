import Foundation

///
/// Use referral model
public struct GLUserReferral: Encodable, Decodable {
    /** User id **/
    public var referrer: String

    public init(referrer: String) {
        self.referrer = referrer
    }
}

///
/// Use data model
public struct GLUser: Encodable, Decodable {
    /** User id **/
    public var id: String?
    /** User email **/
    public var email: String?
    /** User first name **/
    public var firstName: String
    /** User last name **/
    public var lastName: String
    /** User referral **/
    public var referral: GLUserReferral?
    /** User hash **/
    public var hash: String
    /** User country **/
    public var country: String?

    public init(id: String, firstName: String, lastName: String, country: String?, referral: GLUserReferral?, hash: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.country = country
        self.referral = referral
        self.hash = hash
    }

    public init(email: String, firstName: String, lastName: String, country: String?, referral: GLUserReferral?, hash: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.country = country
        self.referral = referral
        self.hash = hash
    }
}

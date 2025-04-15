import z from "zod";
import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";

const AttackSchema = z.object({
    monsters: z.any(),
});
    
export const validateAttack: KoaController = async (ctx) => {
    const { monsters } = AttackSchema.parse(ctx.request.body);

    console.log("validateAttack Monsters:", monsters);
    ctx.status = Status.OK;
    ctx.body = {};
}
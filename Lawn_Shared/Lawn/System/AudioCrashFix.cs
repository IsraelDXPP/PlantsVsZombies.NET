#if LAWNMOD
using System;
using System.Reflection;
using System.Reflection.Emit;
using MonoMod.RuntimeDetour;

namespace Lawn
{
    internal static class AudioCrashFix
    {
        private static Hook s_hook;

        public static void Apply()
        {
            if (s_hook != null)
                return;

            try
            {
                Assembly mgAsm = typeof(Microsoft.Xna.Framework.Game).Assembly;
                Type rbType = mgAsm.GetType("NVorbis.RingBuffer");
                if (rbType == null)
                    return;

                MethodInfo removeItems = rbType.GetMethod("RemoveItems",
                    BindingFlags.Instance | BindingFlags.NonPublic);
                if (removeItems == null)
                    return;

                FieldInfo lengthField = rbType.GetField("_length",
                    BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo startField = rbType.GetField("_start",
                    BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo bufferField = rbType.GetField("_buffer",
                    BindingFlags.Instance | BindingFlags.NonPublic);
                if (lengthField == null || startField == null || bufferField == null)
                    return;

                var dm = new DynamicMethod("RemoveItemsSafe", typeof(void),
                    new Type[] { rbType, typeof(int) },
                    typeof(AudioCrashFix).Module,
                    skipVisibility: true);

                ILGenerator il = dm.GetILGenerator();
                Label skipClamp = il.DefineLabel();
                Label returnLabel = il.DefineLabel();
                LocalBuilder countLocal = il.DeclareLocal(typeof(int));

                il.Emit(OpCodes.Ldarg_1);
                il.Emit(OpCodes.Stloc, countLocal);

                il.Emit(OpCodes.Ldloc, countLocal);
                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldfld, lengthField);
                il.Emit(OpCodes.Ble_S, skipClamp);

                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldfld, lengthField);
                il.Emit(OpCodes.Stloc, countLocal);

                il.MarkLabel(skipClamp);

                il.Emit(OpCodes.Ldloc, countLocal);
                il.Emit(OpCodes.Ldc_I4_0);
                il.Emit(OpCodes.Ble_S, returnLabel);

                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldfld, lengthField);
                il.Emit(OpCodes.Ldloc, countLocal);
                il.Emit(OpCodes.Sub);
                il.Emit(OpCodes.Stfld, lengthField);

                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldfld, startField);
                il.Emit(OpCodes.Ldloc, countLocal);
                il.Emit(OpCodes.Add);
                il.Emit(OpCodes.Ldarg_0);
                il.Emit(OpCodes.Ldfld, bufferField);
                il.Emit(OpCodes.Ldlen);
                il.Emit(OpCodes.Conv_I4);
                il.Emit(OpCodes.Rem);
                il.Emit(OpCodes.Stfld, startField);

                il.MarkLabel(returnLabel);
                il.Emit(OpCodes.Ret);

                s_hook = new Hook(removeItems, dm);
            }
            catch
            {
            }
        }
    }
}
#endif

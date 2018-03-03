﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	РезультатыПроверки = ВладелецФормы.ПолучитьРезультатыПроверкиСоотношенияПоказателей();
	ВывестиРезультатыПроверки();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтобразитьТолькоОшибочныеКС = Истина;
	
	ВывестиРезультатыПроверки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьТолькоОшибочныеКСПриИзменении(Элемент)
		
	ВывестиРезультатыПроверки();
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРезультатыПроверки()

	ПолеТабличногоДокументаКС.Очистить();
	
	МакетРезультатКонтроляСоотношений = Отчеты.РегламентированныйОтчетБухОтчетность.ПолучитьМакет("РезультатКонтроляСоотношений");
	
	СекцияЗаголовок = МакетРезультатКонтроляСоотношений.ПолучитьОбласть("Заголовок");
	
	ПолеТабличногоДокументаКС.Вывести(СекцияЗаголовок);
	
	СекцияСтрокаДанных1 = МакетРезультатКонтроляСоотношений.ПолучитьОбласть("СтрокаДанных1");
	ПорядковыйНомерСтроки = 1;
	
	Для Каждого СтрокаРезультатаПроверки Из РезультатыПроверки Цикл
		
		Если ОтобразитьТолькоОшибочныеКС И СтрокаРезультатаПроверки.РезультатПроверки Тогда
			Продолжить;
		КонецЕсли;
		
		СекцияСтрокаДанных1.Параметры.Номер = ПорядковыйНомерСтроки;
		СекцияСтрокаДанных1.Параметры.ПроверяемоеСоотношение = СтрокаРезультатаПроверки.ПроверяемоеСоотношение;
		
		Если СтрокаРезультатаПроверки.РезультатПроверки Тогда
			СекцияСтрокаДанных1.Параметры.РезультатПроверки = "Соотношение соблюдено";
		Иначе
			СекцияСтрокаДанных1.Параметры.РезультатПроверки = "Соотношение не соблюдено";
		КонецЕсли;
		
		СекцияСтрокаДанных1.Параметры.ОписаниеНарушения = СтрокаРезультатаПроверки.ОписаниеНарушения;
		
		ПолеТабличногоДокументаКС.Вывести(СекцияСтрокаДанных1);
		
		ПорядковыйНомерСтроки = ПорядковыйНомерСтроки + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
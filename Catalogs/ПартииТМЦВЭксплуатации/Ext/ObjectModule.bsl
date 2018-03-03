﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДатаЗавершенияЭксплуатации = КонецМесяца(ДобавитьМесяц(Дата, СрокЭксплуатации));
	
	//++ НЕ УТ
	Если ИнвентарныйУчет
		И (СпособПогашенияСтоимостиБУ = Перечисления.СпособыПогашенияСтоимостиТМЦ.ПоНаработке) Тогда
		ДатаЗавершенияЭксплуатации = Неопределено;
	КонецЕсли;
	//-- НЕ УТ
	
	СформироватьНаименование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФукнции

Процедура СформироватьНаименование()
	
	Шаблон = НСтр("ru='Выдано %Дата% на %СрокЭксплуатации% мес. (до %ДатаЗавершенияЭксплуатации%)'");
	
	//++ НЕ УТ
	Если ИнвентарныйУчет Тогда
		Если СпособПогашенияСтоимостиБУ = Перечисления.СпособыПогашенияСтоимостиТМЦ.ПоНаработке Тогда
			Шаблон = НСтр("ru='Инв.№ ""%ИнвентарныйНомер%"" выдан %Дата% на %ОбъемНаработки% %ЕдиницаИзмеренияНаработки% наработки'");
		Иначе
			Шаблон = НСтр("ru='Инв.№ ""%ИнвентарныйНомер%"" выдан %Дата% на %СрокЭксплуатации% мес. (до %ДатаЗавершенияЭксплуатации%)'");
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
	Шаблон = СтрЗаменить(Шаблон, "%Дата%", Формат(Дата, "ДЛФ=D"));
	Шаблон = СтрЗаменить(Шаблон, "%СрокЭксплуатации%", СрокЭксплуатации);
	Шаблон = СтрЗаменить(Шаблон, "%ДатаЗавершенияЭксплуатации%", Формат(ДатаЗавершенияЭксплуатации, "ДЛФ=D"));
	//++ НЕ УТ
	Если ИнвентарныйУчет Тогда
		Шаблон = СтрЗаменить(Шаблон, "%ИнвентарныйНомер%", СокрЛП(ИнвентарныйНомер));
		Шаблон = СтрЗаменить(Шаблон, "%ОбъемНаработки%", ОбъемНаработки);
		Шаблон = СтрЗаменить(Шаблон, "%ЕдиницаИзмеренияНаработки%", ЕдиницаИзмеренияНаработки);
	КонецЕсли;
	//-- НЕ УТ
	
	Наименование = Шаблон;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
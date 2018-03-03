﻿////////////////////////////////////////////////////////////////////////////////
//
//   Базовая реализация подсистемы персонифицированного учета.
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТЗаписиСтажаПоДаннымУчета(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод, ПараметрыПолученияДанных, ПараметрыОтбора) Экспорт
	ПараметрыОтбораСтажа = УчетСтажаПФР.ПараметрыОтбораСоздатьВТДанныеУчетаСтажаПФР();
	ПараметрыОтбораСтажа.Организация = Организация;
	ПараметрыОтбораСтажа.НачалоПериода = ОтчетныйПериод;
	ПараметрыОтбораСтажа.ОкончаниеПериода = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаСтажаПерсУчета(ОтчетныйПериод);
	
	Если ПараметрыОтбора.СписокФизическихЛиц <> Неопределено Тогда	
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("СписокФизическихЛиц", ПараметрыОтбора.СписокФизическихЛиц);
		Запрос.УстановитьПараметр("ГоловнаяОрганизация", ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Организация));
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФильтрДляФормированияСтажа
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Ссылка В(&СписокФизическихЛиц)";
		
		Запрос.Выполнить();
		
		ПараметрыОтбораСтажа.ИмяВТОтбор = "ВТФильтрДляФормированияСтажа";
		ПараметрыОтбораСтажа.ИзмеренияОтбора.Добавить("ФизическоеЛицо");
		ПараметрыОтбораСтажа.ИзмеренияОтбора.Добавить("ГоловнаяОрганизация");
		
	КонецЕсли;	
		
	УчетСтажаПФР.СоздатьВТДанныеУчетаСтажаПФР(МенеджерВременныхТаблиц, ПараметрыОтбораСтажа, "ВТЗаписиСтажаПоДаннымУчета");
КонецПроцедуры	

Процедура СоздатьВТЗарегистрированныеКорректировкиСтажа(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОтчетныйПериод", ОтчетныйПериод);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК ФизическоеЛицо,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК КорректируемыйПериод
	|ПОМЕСТИТЬ ВТЗарегистрированныеКорректировкиСтажа
	|ГДЕ
	|	ЛОЖЬ";
	
	Запрос.Выполнить();
КонецПроцедуры	

Функция КвартальнаяОтчетностьПерераспределятьВзносыАвтоматически() Экспорт 
	Возврат Истина;	
КонецФункции

Процедура КвартальнаяОтчетностьПФРДополнитьКомандыФормы(Форма) Экспорт
	
КонецПроцедуры

Процедура КвартальнаяОтчетностьПФРОбновитьДанныеФормы(Форма) Экспорт
	
КонецПроцедуры

Функция ПараметрыДляСоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод, СписокФизическихЛиц) Экспорт
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Организация;
	ПараметрыПолученияСотрудников.НачалоПериода = НачалоМесяца(ОтчетныйПериод);
	ПараметрыПолученияСотрудников.ОкончаниеПериода = КонецМесяца(ОтчетныйПериод);
	ПараметрыПолученияСотрудников.КадровыеДанные = "ГоловнаяОрганизация, ЯвляетсяПрокурором, ЯвляетсяВоеннослужащим, РаботаетВСтуденческомОтряде, ВидЗастрахованногоЛица, СтраховойНомерПФР";
	
	Если СписокФизическихЛиц <> Неопределено Тогда
		ПараметрыПолученияСотрудников.СписокФизическихЛиц = СписокФизическихЛиц;
	КонецЕсли;
	
	Если ПараметрыПолученияСотрудников.Свойство("РаботникиПоДоговорамГПХ") Тогда
		ПараметрыПолученияСотрудников.РаботникиПоДоговорамГПХ = Истина;
	КонецЕсли;
	
	Возврат ПараметрыПолученияСотрудников;
	
КонецФункции

Процедура СоздатьВТДосрочноеНазначениеПенсииДляСЗВ_СТАЖ(МенеджерВременныхТаблиц, Организация, Год, ЗаписиОСтаже) Экспорт
	
	ФизическиеЛица = Новый Массив;
	
	ОснованияВыслугиЛетСотрудников = Новый ТаблицаЗначений;
	ОснованияВыслугиЛетСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ОснованияВыслугиЛетСотрудников.Колонки.Добавить("ОсобыеУсловияТруда", Новый ОписаниеТипов("СправочникСсылка.ОсобыеУсловияТрудаПФР,СправочникСсылка.ОсобыеУсловияТрудаДляСЗВКПФР"));
	ОснованияВыслугиЛетСотрудников.Колонки.Добавить("КодПозицииСписка", Новый ОписаниеТипов("СправочникСсылка.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения"));
	
	Для Каждого СтрокаСотрудника Из ЗаписиОСтаже Цикл 
		Если Не ЗначениеЗаполнено(СтрокаСотрудника.ОсобыеУсловияТруда) Тогда 
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ОснованияВыслугиЛетСотрудников.Добавить(), СтрокаСотрудника);
		ФизическиеЛица.Добавить(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
	ОснованияВыслугиЛетСотрудников.Свернуть("Сотрудник,ОсобыеУсловияТруда,КодПозицииСписка");
	
	ОтчетныйПериод = Дата(Год, 1, 1);
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	
	ПараметрыПолученияСотрудников.Организация = Организация;
	ПараметрыПолученияСотрудников.НачалоПериода = ОтчетныйПериод; 
	ПараметрыПолученияСотрудников.ОкончаниеПериода = КонецГода(ОтчетныйПериод); 
	ПараметрыПолученияСотрудников.КадровыеДанные = "ФизическоеЛицо, Подразделение, Должность";
	
	Если ПараметрыПолученияСотрудников.Свойство("РаботникиПоДоговорамГПХ") Тогда
		ПараметрыПолученияСотрудников.РаботникиПоДоговорамГПХ = Истина;
	КонецЕсли;	
	
	ПараметрыПолученияСотрудников.СписокФизическихЛиц = ФизическиеЛица;
	
	УстановитьПривилегированныйРежим(Истина);
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Ложь, ПараметрыПолученияСотрудников);
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ОснованияВыслугиЛетСотрудников", ОснованияВыслугиЛетСотрудников);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОснованияВыслугиЛетСотрудников.Сотрудник КАК ФизическоеЛицо,
	               |	ОснованияВыслугиЛетСотрудников.ОсобыеУсловияТруда КАК ОсобыеУсловияТруда,
	               |	ОснованияВыслугиЛетСотрудников.КодПозицииСписка КАК КодПозицииСписка
	               |ПОМЕСТИТЬ ВТОснованияВыслугиЛет
	               |ИЗ
	               |	&ОснованияВыслугиЛетСотрудников КАК ОснованияВыслугиЛетСотрудников
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СотрудникиОрганизации.Подразделение КАК Подразделение,
	               |	СотрудникиОрганизации.Должность КАК Должность,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СотрудникиОрганизации.ФизическоеЛицо) КАК КоличествоРаботающих,
	               |	ОснованияВыслугиЛет.ОсобыеУсловияТруда КАК ОснованиеВыслугиЛет,
	               |	ОснованияВыслугиЛет.КодПозицииСписка КАК КодПозицииСписка
	               |ПОМЕСТИТЬ ВТДосрочноеНазначениеПенсии
	               |ИЗ
	               |	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОснованияВыслугиЛет КАК ОснованияВыслугиЛет
	               |		ПО СотрудникиОрганизации.ФизическоеЛицо = ОснованияВыслугиЛет.ФизическоеЛицо
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СотрудникиОрганизации.Подразделение,
	               |	СотрудникиОрганизации.Должность,
	               |	ОснованияВыслугиЛет.ОсобыеУсловияТруда,
	               |	ОснованияВыслугиЛет.КодПозицииСписка";
				   
	Запрос.Выполнить();			   
	
КонецПроцедуры

Процедура СоздатьВТЗамещениеГосударственныхДолжностей(МенеджерВременныхТаблиц) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 0
	               |	ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка) КАК Должность,
	               |	ЗНАЧЕНИЕ(Справочник.ЗамещениеГосударственныхМуниципальныхДолжностейПФР.ПустаяСсылка) КАК ЗамещениеГосударственныхМуниципальныхДолжностей
	               |ПОМЕСТИТЬ ВТЗамещениеГосударственныхДолжностей";
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти
